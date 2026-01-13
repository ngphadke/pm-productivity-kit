---
name: excalidraw
description: Create Excalidraw diagrams and flowcharts from text descriptions, export to SVG/PNG, and integrate into documents. Use this skill when the user wants to create diagrams, flowcharts, architecture diagrams, sequence flows, decision trees, or any visual representation. Also use when user mentions "excalidraw", "diagram", "flowchart", "visual", or wants to export diagrams to images.
allowed-tools: Bash, Write, Read, WebFetch
---

# Excalidraw Diagram Creator

Create professional diagrams and flowcharts, export them to SVG/PNG, and integrate into markdown documents.

## Capabilities

1. **Create** - Generate `.excalidraw` files from text-based DSL
2. **Export** - Convert to SVG (via Kroki) or PNG
3. **Preview** - Open in Excalidraw.com for editing
4. **Integrate** - Add diagrams to markdown files or documentation folders

## Dependencies

Dependencies are **auto-installed** when the plugin loads via SessionStart hook. If manual install is needed:
```bash
npm install -g @swiftlysingh/excalidraw-cli
```

## Complete Workflow

### 1. Create the Diagram

Write DSL and generate the `.excalidraw` file:

```bash
# Inline for simple diagrams
excalidraw-cli create --inline "(Start) -> [Process] -> (End)" -o diagram.excalidraw

# From file for complex diagrams
excalidraw-cli create diagram.dsl -o diagram.excalidraw
```

### 2. Export to SVG or PNG

Use the plugin's export script:

```bash
# Export to SVG (uses Kroki API)
bash ${CLAUDE_PLUGIN_ROOT}/scripts/export-diagram.sh diagram.excalidraw diagram.svg

# Export to PNG (requires ImageMagick: brew install imagemagick)
bash ${CLAUDE_PLUGIN_ROOT}/scripts/export-diagram.sh diagram.excalidraw diagram.png
```

Or manually via Kroki API:
```bash
# Encode and fetch SVG
ENCODED=$(cat diagram.excalidraw | python3 -c "import sys,base64,zlib; print(base64.urlsafe_b64encode(zlib.compress(sys.stdin.read().encode(),9)).decode())")
curl -s "https://kroki.io/excalidraw/svg/${ENCODED}" -o diagram.svg
```

### 3. Preview and Edit

For interactive editing, open in Excalidraw.com:
- Read the `.excalidraw` file content
- Go to https://excalidraw.com
- Use File → Open to load the file

### 4. Integrate into Documents

**Markdown with SVG:**
```markdown
![Architecture Diagram](./diagrams/architecture.svg)
```

**Markdown with PNG:**
```markdown
![Flow Chart](./docs/images/flow.png)
```

**Obsidian (native support):**
```markdown
![[diagram.excalidraw]]
```

## DSL Syntax Reference

### Node Types

| Syntax | Shape | Use For |
|--------|-------|---------|
| `[Label]` | Rectangle | Process steps, actions, components |
| `{Label}` | Diamond | Decisions, conditionals, branches |
| `(Label)` | Ellipse | Start/end points, terminals |
| `[[Label]]` | Database cylinder | Data stores, databases |

### Connections

| Syntax | Type | Use For |
|--------|------|---------|
| `->` | Solid arrow | Normal flow |
| `-->` | Dashed arrow | Optional/async flow |
| `-> "label" ->` | Labeled arrow | Annotated connections |

### Directives

Place at the top of your DSL file:
- `@direction TB` - Top to bottom (default)
- `@direction LR` - Left to right
- `@direction BT` - Bottom to top
- `@direction RL` - Right to left
- `@spacing 80` - Node spacing in pixels (default: 60)

## Examples

### Simple Flow
```
(Start) -> [Process Data] -> [Validate] -> (End)
```

### Decision Flow
```
@direction TB

(Start) -> [Check Input]
[Check Input] -> {Valid?}
{Valid?} -> "yes" -> [Process]
{Valid?} -> "no" -> [Show Error]
[Process] -> (End)
[Show Error] -> (End)
```

### Architecture Diagram
```
@direction LR
@spacing 80

[Client] -> [API Gateway]
[API Gateway] -> [Auth Service]
[API Gateway] -> [User Service]
[User Service] -> [[User DB]]
[Auth Service] -> [[Session Store]]
```

### CI/CD Pipeline
```
@direction LR

[Commit] -> [Build] -> [Test] -> {Tests Pass?}
{Tests Pass?} -> "yes" -> [Deploy Staging]
{Tests Pass?} -> "no" -> [Notify Team]
[Deploy Staging] -> {QA Approved?}
{QA Approved?} -> "yes" -> [Deploy Prod]
{QA Approved?} -> "no" -> [Fix Issues]
[Fix Issues] -> [Commit]
```

## CLI Options

```bash
excalidraw-cli create [input] [options]
```

Options:
- `-o, --output <file>` - Output file path (default: flowchart.excalidraw)
- `-d, --direction <dir>` - Flow direction (TB, BT, LR, RL)
- `-s, --spacing <n>` - Node spacing in pixels
- `--inline <dsl>` - DSL string directly
- `--verbose` - Show detailed output

## Best Practices

### For Creating Diagrams
- Ask clarifying questions if requirements are unclear
- Use meaningful labels (2-4 words)
- Choose direction based on content:
  - `LR` for process flows, pipelines, timelines
  - `TB` for hierarchies, decision trees, org charts
- Break complex diagrams into multiple smaller ones

### For Export and Integration
- Use SVG for web/markdown (scales perfectly)
- Use PNG for documents that don't support SVG
- Create a `diagrams/` or `docs/images/` folder for organization
- Name files descriptively: `user-auth-flow.svg`, `system-architecture.svg`

### Output Locations
- `./diagrams/` - Project diagrams
- `./docs/images/` - Documentation images
- Same directory as related markdown files
