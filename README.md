# Generalized AI Issue Classifier

A flexible, config-driven GitHub workflow that automatically classifies issues using AI and executes customizable actions based on the classification results.
## Setup

### Prerequisites
1. **Enable GitHub Models** in your organization settings
   - Go to organization settings → Code, planning, and automation → Models
   - Enable GitHub Models for development
   - Grant access to GitHub Models

### Installation
1. Copy the workflow: `.github/workflows/ai-issue-classifier.yml`
2. Copy the prompt template: `.github/prompts/classify-issue.prompt.yml`
3. Create config files in `.github/configs/` (see examples below)
4. Update usernames and settings in your config files

## Configuration

### Basic Config Structure
```json
{
  "name": "Educational Issue Classifier",
  "model": "openai/gpt-4o-mini",
  "prompt": {
    "system_role": "educational assistant that classifies student GitHub issues",
    "user_instruction": "Classify this GitHub issue from a student"
  },
  "categories": [
    {
      "id": "submission",
      "description": "Assignment completed and ready for instructor review",
      "indicators": ["completed", "finished", "done", "@instructor mentions"],
      "actions": [
        {
          "type": "comment",
          "template": "🎉 **Assignment Submission Received!**\n\nHi @{{author}}! Your assignment submission has been recorded.\n\n**Repository:** {{repository}}\n**Submitted:** {{created_at}}\n**AI Analysis:** {{reasoning}}\n**Confidence:** {{confidence}} ✅\n\nInstructors have been notified. Great work! 🚀\n\n---\n*This issue was automatically processed using AI classification.*"
        },
        {
          "type": "add_labels",
          "labels": ["assignment-submission", "completed", "ai-processed"]
        },
        {
          "type": "close_issue"
        },
        {
          "type": "notify_users",
          "users": ["massarin", "seawaR", "larnsce"]
        }
      ]
    },
    {
      "id": "question",
      "description": "Student needs help or has a question",
      "indicators": ["error", "stuck", "how", "why", "help"],
      "actions": [
        {
          "type": "assign_users",
          "users": ["massarin", "seawaR", "larnsce"]
        },
        {
          "type": "comment",
          "template": "👋 **Question Detected**\n\nHi @{{author}}! I've identified this as a question or help request.\n\n**AI Analysis:** {{reasoning}}\n**Confidence:** {{confidence}} ✅\n\nInstructors have been assigned and will respond soon.\n\n**Need urgent help?** Please reach out via course communication channels."
        },
        {
          "type": "add_labels",
          "labels": ["question", "needs-instructor-review", "ai-processed"]
        }
      ]
    }
  ],
  "fallback": {
    "assign_users": ["massarin", "seawaR", "larnsce"],
    "labels": ["needs-manual-review", "ai-failed"],
    "error_template": "🤖 **AI Classification Failed**\n\nHi @{{author}}! Our AI classifier encountered an issue processing your request.\n\nInstructors have been notified for manual review.\n\n**Sorry for the inconvenience!** Your issue will be handled manually."
  }
}
```

### Available Actions
- `comment`: Post a comment with template
- `add_labels`: Add labels to the issue
- `assign_users`: Assign users to the issue
- `close_issue`: Close the issue
- `notify_users`: Assign users and optionally comment

## How It Works
1. **Action Execution**: Executes configured actions based on classification result
2. **Error Handling**: Falls back to manual review if classification fails