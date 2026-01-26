# Orchestrator Control

Control the prompt-orchestrator plugin's always-on mode and settings.

## Usage

```bash
/orchestrator <command>
```

## Commands

### `/orchestrator on`
Activate always-on orchestration mode.
- Automatically orchestrates vague prompts
- Quality gates before execution
- Cost optimization enabled

### `/orchestrator off`
Deactivate always-on orchestration mode.
- Prompts go directly to execution
- No quality gates or optimization
- Manual control only

### `/orchestrator status`
Show current orchestrator status.
- Active/inactive state
- Current session info
- Quality score if available

### `/orchestrator reset`
Reset all orchestrator state.
- Clear session data
- Reset quality scores
- Start fresh

## Bypass Options

When orchestrator is active, you can bypass it for specific prompts:

### `!raw <prompt>`
Execute prompt directly without orchestration.
- Useful for clear, specific prompts
- Skips quality gate
- No optimization

### Direct Command Invocation
Use `/orchestrate` command for manual orchestration:
```bash
/orchestrate "Your prompt here"
```

## Configuration

The orchestrator uses these settings (stored in `.claude/prompt-orchestrator/config.json`):

```json
{
  "auto_orchestrate": true,
  "quality_threshold": 85,
  "max_discovery_rounds": 5,
  "cost_limit_per_session": 1.00
}
```

## Quality Thresholds

- **≥ 85**: Ready for direct execution
- **70-84**: Suggest refinement
- **< 70**: Return to discovery

## Cost Management

The orchestrator tracks costs per session:
- Discovery: ~$0.05 per round
- Refinement: ~$0.03 per assessment
- Execution: Varies by model (Haiku: $0.08, Sonnet: $0.18, Opus: $0.42)

Session limit: $1.00 (configurable)

## Examples

```bash
# Activate always-on mode
/orchestrator on

# Check status
/orchestrator status

# Bypass for one prompt
!raw Fix the typo in the README

# Deactivate
/orchestrator off

# Reset state
/orchestrator reset
```

## Integration with Hooks

The orchestrator uses Claude Code hooks:
- **SessionStart**: Initializes state and checks mode
- **UserPromptSubmit**: Quality gate and orchestration trigger

These hooks work automatically when the plugin is enabled.