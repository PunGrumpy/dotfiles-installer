---
name: Workflow Failure
about: An issue is created when a workflow fails.
title: Workflow Failure in {{ github.workflow }} run
labels: bug, workflow
assignees: 'PunGrumpy'
---

## Workflow Failure

The workflow run [{{ github.workflow }}]({{ github.server_url }}/{{ github.repository }}/actions/runs/{{ github.run_id }}) failed.

### Details

**Error message:** _The error message is not directly available in the `github` context or the event payload. It should be manually extracted from the logs and inserted here._

**Logs:** [View logs]({{ github.server_url }}/{{ github.repository }}/actions/runs/{{ github.run_id }})

**Workflow run ID:** {{ github.run_id }}
