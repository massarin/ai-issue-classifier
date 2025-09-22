# AI Issue Classifier

Automatically classify GitHub issues using AI and execute configurable actions.

## Quick Start

Add this workflow to `.github/workflows/ai-classifier.yml`:

```yaml
name: AI Issue Classifier
on:
  issues:
    types: [opened, reopened]

jobs:
  classify:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
      models: read
    steps:
      - uses: massarin/ai-issue-classifier@main
        with:
          categories: |
            bug:
              description: "Software defect or error"
              actions:
                - type: add_labels
                  labels: ["bug"]
                - type: assign_users
                  users: ["alice", "bob"]
            feature:
              description: "New feature request"
              actions:
                - type: add_labels
                  labels: ["enhancement"]
```

## Configuration

### Categories
Define classification categories and actions:

```yaml
categories: |
  category_name:
    description: "What this category represents"
    actions:
      - type: comment
        template: "Hello @{{author}}! {{reasoning}}"
      - type: add_labels
        labels: ["label1", "label2"]
      - type: assign_users
        users: ["user1", "user2"]
      - type: close_issue
```

### Template Variables
Use these in comment templates:
- `{{author}}` - Issue creator
- `{{title}}` - Issue title
- `{{body}}` - Issue body
- `{{reasoning}}` - AI reasoning
- `{{confidence}}` - AI confidence
- `{{repository}}` - Repository name
- `{{created_at}}` - Creation date

### Fallback
Handle classification failures:

```yaml
fallback: |
  assign_users: ["admin"]
  labels: ["needs-review"]
  comment: "Manual review needed."
```

## Examples

### Educational Setup
```yaml
categories: |
  submission:
    description: "Assignment completed"
    actions:
      - type: comment
        template: "🎉 Submission received @{{author}}!"
      - type: close_issue
      - type: assign_users
        users: ["instructor"]
  question:
    description: "Student needs help"
    actions:
      - type: assign_users
        users: ["instructor"]
      - type: add_labels
        labels: ["question"]
```

### Support System
```yaml
categories: |
  billing:
    description: "Payment issues"
    actions:
      - type: assign_users
        users: ["billing-team"]
  technical:
    description: "Technical problems"
    actions:
      - type: assign_users
        users: ["tech-support"]
```

## Prerequisites

1. Enable **GitHub Models** in organization settings
2. Grant access to GitHub Models for development

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `categories` | YAML classification config | Required |
| `fallback` | Fallback actions for errors | Basic fallback |
| `model` | AI model to use | `openai/gpt-4o-mini` |

## Outputs

| Output | Description |
|--------|-------------|
| `classification` | AI classification result |
| `confidence` | Confidence level (high/medium/low) |
| `reasoning` | AI reasoning explanation |