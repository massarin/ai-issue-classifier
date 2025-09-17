# Generalized AI Issue Classifier

A flexible, config-driven GitHub workflow that automatically classifies issues using AI and executes customizable actions based on the classification results. Built for educational repositories but generalizable to any classification scenario.

## Features

- **Config-driven**: Define classifications, actions, and templates in YAML files
- **Multi-config support**: Automatically runs for all config files in `.github/configs/`
- **Native GitHub templating**: Uses `${{ }}` syntax for dynamic content
- **Structured AI responses**: JSON schema ensures reliable classification
- **Flexible actions**: Comments, labels, assignments, notifications, issue closing
- **Robust error handling**: Graceful fallback for classification failures

## Setup

### Prerequisites
1. **Enable GitHub Models** in your organization settings
   - Go to organization settings → Code, planning, and automation → Models
   - Enable GitHub Models for development
   - Grant access to GitHub Models

### Installation
1. Copy the workflow: `.github/workflows/ai-issue-classifier.yml`
2. Create config files in `.github/configs/` (see examples below)
3. Update usernames and settings in your config files

## Configuration

### Basic Config Structure
```yaml
# .github/configs/educational.yml
name: "Educational Issue Classifier"
model: "openai/gpt-4o-mini"

prompt:
  system_role: "educational assistant that classifies student GitHub issues"
  user_instruction: "Classify this GitHub issue from a student"

categories:
  - id: "submission"
    description: "Assignment completed and ready for instructor review"
    indicators: ["completed", "finished", "done", "@instructor mentions"]
    actions:
      - type: "comment"
        template: |
          🎉 **Assignment Submission Received!**
          
          Hi @${{ github.event.issue.user.login }}! Your assignment submission has been recorded.
          
          **Repository:** ${{ github.repository }}
          **AI Analysis:** ${{ env.AI_REASONING }}
      - type: "add_labels"
        labels: ["assignment-submission", "completed"]
      - type: "close_issue"

  - id: "question"
    description: "Student needs help or has a question"
    indicators: ["error", "stuck", "how", "why", "help"]
    actions:
      - type: "assign_users"
        users: ["instructor1", "instructor2"]
      - type: "add_labels"
        labels: ["question", "needs-review"]

fallback:
  assign_users: ["admin"]
  labels: ["needs-manual-review", "ai-failed"]
  error_template: |
    🤖 **AI Classification Failed**
    
    Hi @${{ github.event.issue.user.login }}! Manual review required.
```

### Available Actions
- `comment`: Post a comment with template
- `add_labels`: Add labels to the issue
- `assign_users`: Assign users to the issue
- `close_issue`: Close the issue
- `notify_users`: Assign users and optionally comment

### Template Variables
Use GitHub's native templating with these available contexts:
- `${{ github.event.issue.user.login }}` - Issue author
- `${{ github.repository }}` - Repository name
- `${{ github.event.issue.created_at }}` - Issue creation time
- `${{ env.AI_REASONING }}` - AI classification reasoning
- `${{ env.AI_CONFIDENCE }}` - AI confidence level

## How It Works

1. **Config Discovery**: Finds all `.yml`/`.yaml` files in `.github/configs/`
2. **Matrix Execution**: Runs classification for each config file in parallel
3. **Dynamic Prompting**: Builds AI prompts from config categories and indicators
4. **AI Classification**: Gets structured JSON response with classification, confidence, reasoning
5. **Action Execution**: Executes configured actions based on classification result
6. **Error Handling**: Falls back to manual review if classification fails

## Example Use Cases

### Educational Repository
- Classify assignment submissions vs. help requests
- Auto-close completed assignments
- Route questions to instructors

### Support Repository
- Classify bug reports vs. feature requests
- Route to appropriate teams
- Apply priority labels

### Project Management
- Classify issues by component/team
- Auto-assign based on keywords
- Set up notification workflows

## Technical Details

- Uses `actions/ai-inference@v1` for AI classification
- JSON schema ensures structured, parseable responses
- Native GitHub templating eliminates custom interpolation
- Matrix strategy enables multi-config processing
- Requires `models: read` permission for GitHub Models access

## Migration from v1

If upgrading from the original hardcoded version:
1. Move hardcoded logic to config files
2. Update templates to use `${{ }}` syntax instead of `{{}}` 
3. Replace custom interpolation with native GitHub templating
4. Configure fallback behavior in config files