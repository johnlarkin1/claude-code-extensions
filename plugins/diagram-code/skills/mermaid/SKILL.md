---
name: mermaid
description: Generate Mermaid diagrams (.mmd, .mermaid files, or markdown code blocks) for flowcharts, sequence diagrams, class diagrams, ER diagrams, state diagrams, Gantt charts, pie charts, mindmaps, timelines, and git graphs. Use when user requests diagrams for documentation, markdown files, README visualizations, or any text-based diagram format that renders in GitHub/GitLab. Triggers on requests mentioning Mermaid, markdown diagrams, documentation diagrams, or when output needs to be embedded in markdown.
tools: Read, Write
---

# Mermaid Diagram Generation

Generate text-based diagrams using Mermaid syntax. Mermaid diagrams render directly in GitHub, GitLab, Notion, and many markdown viewers.

## Quick Start

Minimal flowchart:
```mermaid
flowchart TD
    A[Start] --> B[End]
```

## Output Formats

1. **Markdown code block** - Embed in `.md` files:
   ````markdown
   ```mermaid
   flowchart TD
       A --> B
   ```
   ````

2. **Standalone file** - `.mmd` or `.mermaid` extension:
   ```
   flowchart TD
       A --> B
   ```

## Workflow

1. **Identify diagram type** - Match user intent to diagram type
2. **Plan structure** - List nodes/entities and relationships
3. **Generate syntax** - Write Mermaid code following type-specific patterns
4. **Output** - Write to file or embed in markdown

## Diagram Types Overview

### Flowchart
Direction: `TD` (top-down), `LR` (left-right), `BT`, `RL`
```mermaid
flowchart TD
    A[Start] --> B{Decision?}
    B -->|Yes| C[Process]
    B -->|No| D[End]
    C --> D
```

### Sequence Diagram
```mermaid
sequenceDiagram
    participant U as User
    participant S as Server
    U->>S: Request
    S-->>U: Response
```

### Class Diagram
```mermaid
classDiagram
    class Animal {
        +String name
        +makeSound()
    }
    class Dog {
        +bark()
    }
    Animal <|-- Dog
```

### Entity Relationship (ER)
```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "ordered in"
```

### State Diagram
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : start
    Processing --> Done : complete
    Done --> [*]
```

### Gantt Chart
```mermaid
gantt
    title Project Timeline
    dateFormat YYYY-MM-DD
    section Phase 1
    Task A :a1, 2024-01-01, 30d
    Task B :after a1, 20d
```

### Pie Chart
```mermaid
pie title Distribution
    "Category A" : 40
    "Category B" : 30
    "Category C" : 30
```

### Mindmap
```mermaid
mindmap
    root((Central Topic))
        Branch A
            Leaf 1
            Leaf 2
        Branch B
            Leaf 3
```

### Timeline
```mermaid
timeline
    title History
    2020 : Event A
    2021 : Event B
    2022 : Event C
```

### Git Graph
```mermaid
gitGraph
    commit
    branch develop
    checkout develop
    commit
    checkout main
    merge develop
    commit
```

## Node Shapes (Flowchart)

| Shape | Syntax | Use For |
|-------|--------|---------|
| Rectangle | `[text]` | Process/action |
| Rounded | `(text)` | Start/end |
| Stadium | `([text])` | Terminal |
| Subroutine | `[[text]]` | Subprocess |
| Database | `[(text)]` | Data store |
| Circle | `((text))` | Connector |
| Diamond | `{text}` | Decision |
| Hexagon | `{{text}}` | Preparation |
| Parallelogram | `[/text/]` | Input/Output |
| Trapezoid | `[/text\]` | Manual operation |

## Arrow Types

| Arrow | Syntax | Meaning |
|-------|--------|---------|
| Solid | `-->` | Flow |
| Dotted | `-.->` | Optional/async |
| Thick | `==>` | Important |
| With text | `-->|label|` | Labeled flow |
| Open | `---` | Association |

## Styling

### Inline styling
```mermaid
flowchart TD
    A[Start]:::green --> B[End]:::red
    classDef green fill:#90EE90
    classDef red fill:#FFB6C1
```

### Theme configuration
```mermaid
%%{init: {'theme': 'forest'}}%%
flowchart TD
    A --> B
```

Available themes: `default`, `forest`, `dark`, `neutral`, `base`

## Critical Rules

1. **Indentation** - Use consistent 4-space indentation
2. **Node IDs** - Use short, unique identifiers (A, B, node1)
3. **Special characters** - Wrap text with special chars in quotes: `A["Text with (parens)"]`
4. **Subgraphs** - Close with `end` keyword
5. **No trailing whitespace** - Can cause parsing issues

## Subgraphs (Flowchart)

```mermaid
flowchart TD
    subgraph Group1[First Group]
        A --> B
    end
    subgraph Group2[Second Group]
        C --> D
    end
    B --> C
```

## When to Use Mermaid

- Documentation in markdown files
- README diagrams (GitHub/GitLab render natively)
- Sequence diagrams for API flows
- Class diagrams for OOP design
- ER diagrams for database schema
- Gantt charts for project planning
- Quick diagrams that don't need precise positioning

## References

See `references/diagram-types.md` for complete examples of each diagram type.
See `references/syntax-reference.md` for detailed syntax and configuration options.
