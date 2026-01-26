#!/usr/bin/env python3
"""
SessionStart hook for prompt-orchestrator plugin.
Initializes orchestrator state and checks if always-on mode is active.
"""

import json
import os
import sys
from pathlib import Path

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
        hooks_config = json.load(f)
    
    # Initialize state directory
    state_dir = Path(os.getcwd()) / hooks_config["state"]["directory"]
    state_dir.mkdir(parents=True, exist_ok=True)
    
    # State file paths
    session_file = state_dir / hooks_config["state"]["session_file"]
    config_file = state_dir / hooks_config["state"]["config_file"]
    
    # Load or create session state
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
    
    # Load or create config
    config = hooks_config["settings"]
    if config_file.exists():
        with open(config_file, 'r') as f:
            existing_config = json.load(f)
            config.update(existing_config)
    
    # Save config
    with open(config_file, 'w') as f:
        json.dump(config, f, indent=2)
    
    # Prepare hook response
    response = {
        "continue": True,
        "state": {
            "orchestrator_active": session_state["active"],
            "auto_orchestrate": config["auto_orchestrate"],
            "quality_threshold": config["quality_threshold"],
            "session_file": str(session_file),
            "state_dir": str(state_dir)
        }
    }
    
    # If auto-orchestrate is enabled and no session is active, activate it
    if config["auto_orchestrate"] and not session_state["active"]:
        session_state["active"] = True
        with open(session_file, 'w') as f:
            json.dump(session_state, f, indent=2)
        
        response["message"] = "🎯 Prompt orchestrator activated (always-on mode)"
        response["state"]["orchestrator_active"] = True
    
    # Output response
    print(json.dumps(response, indent=2))

if __name__ == "__main__":
    main()