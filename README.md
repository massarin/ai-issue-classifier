# AI Assignment Issue Classifier

A GitHub workflow that automatically classifies student issues as assignment submissions or questions using AI with structured output, then responds with helpful messages.

## Setup

### Prerequisites
1. **Enable GitHub Models** in your organization settings (required for AI classification)
   - Go to your organization settings
   - Navigate to Code, planning, and automation  → Models → GitHub Models for development → Enabled
   - Enable access to GitHub Models

### Installation
1. Copy the workflow file: `.github/workflows/structured-ai-classifier.yml`
2. Copy the prompt file: `.github/prompts/classification.prompt.yml`
3. Update instructor usernames in the workflow file

## How It Works

1. **Issue Detection**: Workflow triggers on new/reopened issues
2. **AI Classification**: Uses structured prompt with JSON schema to classify as "submission" or "question" 
3. **Intelligent Response**: 
   - **Submissions**: Posts congratulatory message, adds labels, closes issue
   - **Questions**: Assigns instructors, adds labels, posts help message
4. **Error Handling**: Falls back to manual review if AI classification fails

## Technical Details

- Uses `actions/ai-inference@v1` with `.prompt.yml` files
- JSON schema ensures structured, parseable responses
- No regex parsing - direct JSON handling
- Requires `models: read` permission for GitHub Models access