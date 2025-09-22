# AI Issue Classifier

A flexible, config-driven GitHub Action that automatically classifies issues using AI and executes customizable actions based on the classification results.

## Quick Start

### 1. Create Workflow
Copy this workflow to `.github/workflows/ai-issue-classifier.yml` in your repository:

```yaml
name: AI Issue Classifier

on:
  issues:
    types: [opened, reopened]

jobs:
  classify-issue:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
      models: read
    steps:
      - name: Classify Issue with AI
        uses: massarin/generalised-ai-issue-classifier@main
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### 2. Configure Classification
Create config files in your `.github` repository (or `{username}/.github` for organization-wide configs)

### 3. Prerequisites
- **Enable GitHub Models** in your organization settings
- Grant access to GitHub Models for development

## Advanced Configuration

## Configuration

### Config Example
```json
{
  "name": "Support Issue Classifier",
  "model": "openai/gpt-4o-mini",
  "categories": [
    {
      "id": "bug",
      "description": "Software defect or error",
      "indicators": ["error", "crash", "broken", "not working"],
      "actions": [
        {
          "type": "comment",
          "template": "🐛 **Bug Report**\n\nHi @{{author}}! Thanks for reporting this.\n\n**Analysis:** {{reasoning}}\n\nDevelopers will investigate soon."
        },
        {
          "type": "add_labels",
          "labels": ["bug", "needs-investigation"]
        },
        {
          "type": "assign_users",
          "users": ["user1", "user2"]
        }
      ]
    },
    {
      "id": "feature",
      "description": "New feature request",
      "indicators": ["feature", "enhancement", "add", "support"],
      "actions": [
        {
          "type": "add_labels",
          "labels": ["enhancement"]
        },
        {
          "type": "close_issue"
        },
        {
          "type": "notify_users",
          "users": ["user3"],
          "message": "New feature request needs review"
        }
      ]
    }
  ],
  "fallback": {
    "assign_users": ["user1"],
    "labels": ["needs-review"],
    "error_template": "🤖 Classification failed. Manual review needed."
  }
}
```

### Available Actions
- `comment`: Post comment with template variables
- `add_labels`: Add labels to issue  
- `assign_users`: Assign users to issue
- `close_issue`: Close the issue
- `notify_users`: Assign users + optional comment message

### Template Variables
- `{{author}}` - Issue creator username
- `{{title}}` - Issue title
- `{{body}}` - Issue body  
- `{{reasoning}}` - AI classification explanation
- `{{confidence}}` - AI confidence level
- `{{repository}}` - Repository name
- `{{created_at}}` - Issue creation timestamp

## How It Works
1. **Action Execution**: Executes configured actions based on classification result
2. **Error Handling**: Falls back to manual review if classification fails