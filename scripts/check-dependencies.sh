#!/bin/bash
# Check and install dependencies for pm-productivity-kit

# Check for excalidraw-cli
if ! command -v excalidraw-cli &> /dev/null; then
    echo "📦 Installing excalidraw-cli..."
    npm install -g @swiftlysingh/excalidraw-cli 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ excalidraw-cli installed successfully"
    else
        echo "⚠️  Failed to install excalidraw-cli. Please run: npm install -g @swiftlysingh/excalidraw-cli"
    fi
else
    echo "✅ excalidraw-cli is available"
fi
