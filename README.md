# PM Productivity Kit

A Claude Code plugin with productivity skills for product managers and makers.

## Installation

```bash
# Add the marketplace (one-time)
/plugin marketplace add ngphadke/pm-productivity-kit

# Install the plugin
/plugin install pm-productivity-kit@ngphadke/pm-productivity-kit
```

Or install directly from local path:
```bash
/plugin install /path/to/pm-productivity-kit
```

## Skills Included

### Excalidraw Diagrams

Create professional diagrams and flowcharts from text descriptions, export to SVG/PNG, and integrate into documents.

**Capabilities:**
- Create `.excalidraw` files from simple text-based DSL
- Export to SVG (via Kroki API) or PNG
- Auto-installs dependencies on first use

**Example usage:**
```
Create a flowchart showing user authentication flow with login,
validation, and either success redirect or error display
```

Claude will generate:
1. The `.excalidraw` file (editable in Excalidraw.com)
2. Optionally export to SVG/PNG for embedding in docs

**DSL Quick Reference:**

| Syntax | Shape | Use |
|--------|-------|-----|
| `[Label]` | Rectangle | Process steps |
| `{Label}` | Diamond | Decisions |
| `(Label)` | Ellipse | Start/End |
| `[[Label]]` | Database | Data stores |
| `->` | Arrow | Connections |
| `-> "text" ->` | Labeled arrow | Annotated flow |

## Coming Soon

- Product Roadmap skill
- PRD writing skill
- User story generator

## Requirements

- Node.js (for npm package installation)
- Python 3 (for Kroki API encoding)
- ImageMagick (optional, for PNG export): `brew install imagemagick`

## License

MIT
