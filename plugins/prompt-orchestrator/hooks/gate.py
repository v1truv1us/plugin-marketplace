#!/usr/bin/env python3
"""
UserPromptSubmit hook for prompt-orchestrator plugin.
Quality gate and orchestration trigger for user prompts.
"""

import json
import os
import sys
from pathlib import Path

def should_bypass(prompt, session_state, config):
    """Check if prompt should bypass orchestration."""
    
    # Check for bypass prefix
    if prompt.startswith(config["bypass"]["prefix"]):
        return True, "bypass_prefix"
    
    # Check for bypass commands
    for cmd in config["bypass"]["commands"]:
        if prompt.strip().startswith(cmd):
            return True, "bypass_command"
    
    # Check if orchestration is in progress and this is a followup
    if session_state.get("waiting_for_followup", False):
        return True, "followup_answer"
    
    # Check if bypass is manually active
    if session_state.get("bypass_active", False):
        return True, "manual_bypass"
    
    return False, None

def handle_orchestrator_command(prompt, session_state, config, state_dir):
    """Handle orchestrator control commands."""
    
    cmd = prompt.strip().lower()
    
    if cmd == "/orchestrator on":
        session_state["active"] = True
        session_state["bypass_active"] = False
        return {
            "continue": True,
            "message": "🎯 Prompt orchestrator activated",
            "orchestrate": False,
            "update_session": session_state
        }
    
    elif cmd == "/orchestrator off":
        session_state["active"] = False
        session_state["bypass_active"] = True
        return {
            "continue": True,
            "message": "⏸️ Prompt orchestrator deactivated",
            "orchestrate": False,
            "update_session": session_state
        }
    
    elif cmd == "/orchestrator status":
        status = "🟢 Active" if session_state["active"] else "🔴 Inactive"
        if session_state.get("orchestration_in_progress", False):
            status += " (orchestrating...)"
        
        return {
            "continue": True,
            "message": f"Status: {status}",
            "orchestrate": False,
            "update_session": None
        }
    
    elif cmd == "/orchestrator reset":
        session_file = state_dir / config["state"]["session_file"]
        if session_file.exists():
            session_file.unlink()
        
        return {
            "continue": True,
            "message": "🔄 Orchestrator state reset",
            "orchestrate": False,
            "update_session": None
        }
    
    return None

def main():
    # Read hook input from stdin
    hook_input = json.load(sys.stdin)
    
    # Get plugin root from environment
    plugin_root = os.environ.get('CLAUDE_PLUGIN_ROOT')
    if not plugin_root:
        print("Error: CLAUDE_PLUGIN_ROOT not set", file=sys.stderr)
        sys.exit(1)
    
    # Load hooks configuration
    hooks_config_path = Path(plugin_root) / "hooks.json"
    with open(hooks_config_path, 'r') as f:
        config = json.load(f)
    
    # Get state paths
    state_dir = Path(os.getcwd()) / config["state"]["directory"]
    session_file = state_dir / config["state"]["session_file"]
    
    # Load session state
    session_state = {
        "active": False,
        "discovery_round": 0,
        "quality_score": 0,
        "last_prompt": "",
        "orchestration_in_progress": False,
        "waiting_for_followup": False,
        "bypass_active": False
    }
    
    if session_file.exists():
        with open(session_file, 'r') as f:
            session_state.update(json.load(f))
    
    # Get user prompt
    user_prompt = hook_input.get("user_prompt", "")
    
    # Handle orchestrator commands first
    command_result = handle_orchestrator_command(user_prompt, session_state, config, state_dir)
    if command_result:
        # Update session if needed
        if command_result.get("update_session"):
            with open(session_file, 'w') as f:
                json.dump(command_result["update_session"], f, indent=2)
        
        print(json.dumps(command_result, indent=2))
        return
    
    # Check if should bypass orchestration
    should_bypass_result, bypass_reason = should_bypass(user_prompt, session_state, config)
    
    if should_bypass_result:
        # For followup answers, clear the waiting flag
        if bypass_reason == "followup_answer":
            session_state["waiting_for_followup"] = False
            session_state["orchestration_in_progress"] = False
            with open(session_file, 'w') as f:
                json.dump(session_state, f, indent=2)
        
        print(json.dumps({
            "continue": True,
            "orchestrate": False,
            "bypass_reason": bypass_reason
        }, indent=2))
        return
    
    # Check if orchestrator is active
    if not session_state["active"]:
        print(json.dumps({
            "continue": True,
            "orchestrate": False
        }, indent=2))
        return
    
    # Trigger orchestration
    session_state["orchestration_in_progress"] = True
    session_state["last_prompt"] = user_prompt
    session_state["discovery_round"] += 1
    
    # Save session state
    with open(session_file, 'w') as f:
        json.dump(session_state, f, indent=2)
    
    # Return orchestration trigger
    print(json.dumps({
        "continue": True,
        "orchestrate": True,
        "prompt": user_prompt,
        "session_state": session_state,
        "prompt_template": config["hooks"]["UserPromptSubmit"]["prompt_template"]
    }, indent=2))

if __name__ == "__main__":
    main()