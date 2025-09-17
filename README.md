# Assignment Issue Classifier

A friendly, configurable GitHub workflow that automatically classifies student issues as assignment submissions or questions, then responds with warm, human-like messages.

## Features

- 🤗 **Human-friendly responses** - Congratulatory messages instead of robotic AI speak
- ⚙️ **Fully configurable** - Customize instructors, messages, and behavior via JSON config
- 🎯 **Smart classification** - Distinguishes between submissions and questions  
- 🔧 **No external dependencies** - Uses native GitHub Actions JSON parsing

## Setup

1. Copy the workflow file to `.github/workflows/assignment-issue-classifier.yml`
2. Copy the prompt file to `.github/prompts/assignment-classifier.prompt.yml` 
3. Customize `.github/config/classifier-config.json` with your course details

## Configuration

Edit `.github/config/classifier-config.json` to customize:

- **Instructors**: List of GitHub usernames to notify
- **Messages**: Custom text for different response types
- **Labels**: What labels to apply to issues
- **Behavior**: Control closing submissions, timestamps, etc.

The workflow gracefully falls back to sensible defaults if no config file is found.