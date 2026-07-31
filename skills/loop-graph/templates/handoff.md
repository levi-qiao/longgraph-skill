<!--
Universal owner handoff. Replace every {{PLACEHOLDER}}, delete this comment, and
print the completed handoff in chat. Host references supply the field values.
-->

# Start this run

Workspace: `{{PROJECT_ROOT}}`
Run files: `{{RUN_DIR}}`

{{SESSION_INSTRUCTION}}

## 1. Start the executor

Where: {{EXECUTOR_DESTINATION}}

Paste:

```text
{{EXECUTOR_LAUNCH}}
```

Continue when: {{EXECUTOR_READY}}

## 2. Start the supervisor

Where: {{SUPERVISOR_DESTINATION}}

Paste:

```text
{{SUPERVISOR_LAUNCH}}
```

## What happens next

{{RUNNING_STATE}}

Context reset: {{RESET_INSTRUCTION}}

To stop: {{STOP_INSTRUCTION}}
