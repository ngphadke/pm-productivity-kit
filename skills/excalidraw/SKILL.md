---
name: excalidraw
description: Create Excalidraw diagrams and flowcharts from text descriptions. Use this skill when the user wants to create diagrams, flowcharts, architecture diagrams, sequence flows, decision trees, or any visual representation that can be opened in Excalidraw. Also use when user mentions "excalidraw", "diagram", "flowchart", or "visual".
allowed-tools: Bash, Write, Read
---

# Excalidraw Diagram Creator

Create professional diagrams and flowcharts using the excalidraw-cli tool. Generate `.excalidraw` files that can be opened in Excalidraw.com, Obsidian, or any Excalidraw-compatible tool.

## Prerequisites

The `excalidraw-cli` tool must be installed:
```bash
npm install -g @swiftlysingh/excalidraw-cli
```

## How to Create Diagrams

### Step 1: Understand the Request
When the user asks for a diagram, identify:
- What type of diagram (flowchart, architecture, sequence, decision tree)
- The components/nodes involved
- The relationships/connections between them
- The preferred direction (top-to-bottom, left-to-right, etc.)

### Step 2: Write the DSL
Convert the user's description into DSL syntax. Save it to a `.dsl` file.

### Step 3: Generate the Diagram
Run the excalidraw-cli command to generate the `.excalidraw` file.

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

## CLI Commands

### Create from inline DSL
```bash
excalidraw-cli create --inline "[A] -> [B] -> [C]" -o diagram.excalidraw
```

### Create from file
```bash
excalidraw-cli create flowchart.dsl -o diagram.excalidraw
```

### With options
```bash
excalidraw-cli create flowchart.dsl -o diagram.excalidraw -d LR -s 80
```

Options:
- `-o, --output <file>` - Output file path
- `-d, --direction <dir>` - Flow direction (TB, BT, LR, RL)
- `-s, --spacing <n>` - Node spacing in pixels
- `--verbose` - Show detailed output

## Workflow

1. **Ask clarifying questions** if the diagram requirements are unclear
2. **Write the DSL** to a `.dsl` file in the current directory or a specified location
3. **Generate the diagram** using excalidraw-cli
4. **Inform the user** where the `.excalidraw` file was created
5. **Suggest next steps** - they can open it in Excalidraw.com or their preferred editor

## Output Locations

- Default: Create in current working directory
- If user specifies a path, use that path
- Common locations:
  - `./diagrams/` for project diagrams
  - `./docs/images/` for documentation
  - Same directory as related files

## Tips

- Use meaningful labels that fit in the shapes
- Keep labels concise (2-4 words)
- For complex diagrams, break into multiple smaller diagrams
- Use `@direction LR` for process flows and pipelines
- Use `@direction TB` for hierarchies and decision trees
- Database shapes `[[]]` work well for any data storage (files, caches, queues)
