# Generalized AI Issue Classifier

A flexible, config-driven GitHub workflow that automatically classifies issues using AI and executes customizable actions based on the classification results.
## Setup

### Prerequisites
1. **Enable GitHub Models** in your organization settings
   - Go to organization settings → Code, planning, and automation → Models
   - Enable GitHub Models for development
   - Grant access to GitHub Models

### Installation
**One-liner installation:**
```bash
git clone https://github.com/your-username/generalised-ai-issue-classifier .github
```

**Manual installation:**
1. Copy `workflows/ai-issue-classifier.yml` to `.github/workflows/`
2. Copy `prompts/classify-issue.prompt.yml` to `.github/prompts/`
3. Copy `configs/educational.json.example` to `.github/configs/educational.json`
4. Update usernames and settings in your config files

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