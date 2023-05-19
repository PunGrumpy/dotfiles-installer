---
name: Workflow Failure
about: An issue is created when a workflow fails.
title: Workflow Failure in {{ env.WORKFLOW_NAME }} run
labels: bug, workflow, installer
assignees: 'PunGrumpy'
---

## Workflow Failure

The workflow run [{{ env.WORKFLOW_NAME }}]({{ env.SERVER_URL }}/{{ env.REPOSITORY }}/actions/runs/{{ env.ACTION_ID }}) failed.

### Details

**Error message:** {{ steps.error_capture.outputs.error }}

**Logs:** [View logs]({{ env.SERVER_URL }}/{{ env.REPOSITORY }}/actions/runs/{{ env.ACTION_ID }})

**Workflow run ID:** {{ env.ACTION_ID }}
