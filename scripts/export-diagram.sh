#!/bin/bash
# Export excalidraw files to SVG or PNG using Kroki API
# Usage: export-diagram.sh <input.excalidraw> [output.svg|output.png]

set -e

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: export-diagram.sh <input.excalidraw> [output.svg|output.png]"
    echo "  If output is not specified, creates <input>.svg"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Determine output file and format
if [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="${INPUT_FILE%.excalidraw}.svg"
fi

EXTENSION="${OUTPUT_FILE##*.}"

# Encode the excalidraw file for Kroki
# Kroki expects deflate + base64 encoded content
ENCODED=$(cat "$INPUT_FILE" | python3 -c "
import sys
import base64
import zlib

data = sys.stdin.read().encode('utf-8')
compressed = zlib.compress(data, 9)
encoded = base64.urlsafe_b64encode(compressed).decode('utf-8')
print(encoded)
")

# Call Kroki API for SVG
if [ "$EXTENSION" = "png" ]; then
    SVG_OUTPUT="${OUTPUT_FILE%.png}.svg"
else
    SVG_OUTPUT="$OUTPUT_FILE"
fi

KROKI_URL="https://kroki.io/excalidraw/svg/${ENCODED}"

echo "Exporting to SVG via Kroki..."
curl -s "$KROKI_URL" -o "$SVG_OUTPUT"

if [ $? -ne 0 ] || [ ! -s "$SVG_OUTPUT" ]; then
    echo "Error: Failed to export via Kroki"
    exit 1
fi

echo "✅ Created: $SVG_OUTPUT"

# Convert to PNG if requested
if [ "$EXTENSION" = "png" ]; then
    echo "Converting SVG to PNG..."

    # Try different conversion methods
    if command -v convert &> /dev/null; then
        # ImageMagick
        convert -density 150 "$SVG_OUTPUT" "$OUTPUT_FILE"
        echo "✅ Created: $OUTPUT_FILE (via ImageMagick)"
    elif command -v rsvg-convert &> /dev/null; then
        # librsvg
        rsvg-convert -o "$OUTPUT_FILE" "$SVG_OUTPUT"
        echo "✅ Created: $OUTPUT_FILE (via rsvg-convert)"
    elif command -v npx &> /dev/null; then
        # Try resvg-cli via npx
        npx @aspect-ratio/resvg-cli "$SVG_OUTPUT" "$OUTPUT_FILE" 2>/dev/null || \
        echo "⚠️  PNG conversion requires ImageMagick, librsvg, or @resvg/resvg-js"
        echo "    Install with: brew install imagemagick"
        echo "    SVG file is available at: $SVG_OUTPUT"
    else
        echo "⚠️  PNG conversion requires ImageMagick or librsvg"
        echo "    Install with: brew install imagemagick"
        echo "    SVG file is available at: $SVG_OUTPUT"
    fi
fi
