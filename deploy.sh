#!/bin/bash

# Simple deployment script for GitHub Actions
# Based on GitHub's recommended practices for composite actions

set -e

echo "🚀 Deploying AI Issue Classifier Action..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "📝 Uncommitted changes detected. Please commit first."
    echo "Run: git add . && git commit -m 'your message'"
    exit 1
fi

# Push current changes to main
echo "📤 Pushing to main..."
git push origin main

# Optional: Create a version tag
echo ""
echo "🏷️  Create version tag? (optional, press Enter to skip)"
echo "Example: v1.0.0, v1.1.0, etc."
read -p "Version: " VERSION

if [ ! -z "$VERSION" ]; then
    # Validate version format
    if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "⚠️  Warning: Version should follow format v1.0.0"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Cancelled"
            exit 1
        fi
    fi

    echo "Creating tag: $VERSION"
    git tag -a "$VERSION" -m "Release $VERSION"
    git push origin "$VERSION"

    # Create/update major version tag (e.g., v1)
    MAJOR_VERSION=$(echo "$VERSION" | cut -d. -f1)
    echo "Updating major version tag: $MAJOR_VERSION"
    git tag -fa "$MAJOR_VERSION" -m "Update $MAJOR_VERSION to $VERSION"
    git push origin "$MAJOR_VERSION" --force
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Users can now reference this action:"
echo "  uses: $(git config --get remote.origin.url | sed 's/.*github\.com[:/]\([^.]*\).*/\1/')@main"
echo ""
if [ ! -z "$VERSION" ]; then
    echo "🏷️  Or use the specific version:"
    echo "  uses: $(git config --get remote.origin.url | sed 's/.*github\.com[:/]\([^.]*\).*/\1/')@$VERSION"
fi