# Mermaid Syntax Reference

Comprehensive syntax guide for Mermaid diagrams.

## Configuration and Directives

### Init Directive
Configure diagram settings at the start:
```mermaid
%%{init: {
  'theme': 'forest',
  'themeVariables': {
    'primaryColor': '#ff0000',
    'primaryTextColor': '#fff',
    'primaryBorderColor': '#7C0000',
    'lineColor': '#F8B229',
    'secondaryColor': '#006100',
    'tertiaryColor': '#fff'
  }
}}%%
flowchart TD
    A --> B
```

### Available Themes
- `default` - Standard Mermaid colors
- `forest` - Green/nature tones
- `dark` - Dark mode
- `neutral` - Grayscale
- `base` - Minimal styling for customization

## Flowchart Syntax

### Directions
| Direction | Meaning |
|-----------|---------|
| `TB` or `TD` | Top to Bottom |
| `BT` | Bottom to Top |
| `LR` | Left to Right |
| `RL` | Right to Left |

### Node Definitions
```mermaid
flowchart TD
    %% With explicit text
    id1[This is the text in the box]

    %% ID as text
    SimpleNode

    %% Unicode and special characters
    id2["Unicode: (括弧)"]

    %% Markdown in nodes
    id3["`**Bold** and *italic*`"]
```

### All Node Shapes Reference
```
[text]      Rectangle (default)
(text)      Rounded rectangle
([text])    Stadium shape
[[text]]    Subroutine
[(text)]    Cylindrical (database)
((text))    Circle
>text]      Asymmetric/flag
{text}      Diamond/rhombus
{{text}}    Hexagon
[/text/]    Parallelogram
[\text\]    Parallelogram (alt)
[/text\]    Trapezoid
[\text/]    Trapezoid (alt)
(((text)))  Double circle
```

### Link/Arrow Styles
```
A --> B     Arrow
A --- B     Line
A -.-> B    Dotted arrow
A -.- B     Dotted line
A ==> B     Thick arrow
A === B     Thick line
A --o B     Circle end
A --x B     Cross end
A o--o B    Circles both ends
A <--> B    Arrows both ends
A -- text --> B    With label
A -->|text| B      With label (alt)
```

### Link Length
```
A --> B         Normal
A ---> B        Longer
A ----> B       Even longer
A -.-> B        Dotted
A -.-.-> B      Longer dotted
A ==> B         Thick
A ===> B        Longer thick
```

### Subgraphs
```mermaid
flowchart TB
    subgraph one [First Subgraph]
        direction LR
        a1 --> a2
    end

    subgraph two [Second Subgraph]
        direction TB
        b1 --> b2
    end

    one --> two
```

### Styling

#### Class Definitions
```mermaid
flowchart TD
    A[Critical]:::critical --> B[Warning]:::warning --> C[Success]:::success

    classDef critical fill:#f00,color:#fff,stroke:#900
    classDef warning fill:#ff0,color:#000,stroke:#990
    classDef success fill:#0f0,color:#000,stroke:#090
```

#### Inline Styles
```mermaid
flowchart TD
    A --> B
    style A fill:#bbf,stroke:#333,stroke-width:2px
    style B fill:#f9f,stroke:#333,stroke-width:4px,color:#fff
```

#### Link Styling
```mermaid
flowchart TD
    A --> B --> C
    linkStyle 0 stroke:#ff0,stroke-width:4px
    linkStyle 1 stroke:#0ff,stroke-width:2px,stroke-dasharray:5
```

## Sequence Diagram Syntax

### Participants
```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob
    actor U as User

    A->>B: Message
    B->>U: Reply
```

### Message Types
```
->>     Solid line with arrowhead
-->>    Dotted line with arrowhead
--)     Solid line with open arrowhead
--)     Dotted line with open arrowhead
-x      Solid line with cross
--x     Dotted line with cross
```

### Activation
```mermaid
sequenceDiagram
    A->>+B: Request
    B-->>-A: Response

    %% Or explicit
    activate B
    B->>C: Forward
    deactivate B
```

### Notes
```mermaid
sequenceDiagram
    A->>B: Message
    Note left of A: Left note
    Note right of B: Right note
    Note over A,B: Spanning note
```

### Loops and Conditionals
```mermaid
sequenceDiagram
    loop Every minute
        A->>B: Heartbeat
    end

    alt Success
        B-->>A: OK
    else Failure
        B-->>A: Error
    end

    opt Optional
        A->>B: Extra request
    end

    par Parallel
        A->>B: Request 1
    and
        A->>C: Request 2
    end

    critical Critical Section
        A->>B: Important
    option Timeout
        A->>A: Retry
    end

    break When error
        A-->>A: Handle error
    end
```

### Auto-numbering
```mermaid
sequenceDiagram
    autonumber
    A->>B: First
    B->>C: Second
    C-->>A: Third
```

## Class Diagram Syntax

### Class Definition
```mermaid
classDiagram
    class ClassName {
        +public_field: Type
        -private_field: Type
        #protected_field: Type
        ~package_field: Type

        +public_method() ReturnType
        -private_method(param: Type) void
        #protected_method()* abstract
        ~package_method()$ static
    }
```

### Visibility Modifiers
| Symbol | Meaning |
|--------|---------|
| `+` | Public |
| `-` | Private |
| `#` | Protected |
| `~` | Package/Internal |

### Method Modifiers
| Symbol | Meaning |
|--------|---------|
| `*` | Abstract |
| `$` | Static |

### Relationships
```
<|--    Inheritance
*--     Composition
o--     Aggregation
-->     Association
--      Link (solid)
..>     Dependency
..|>    Realization
..      Link (dashed)
```

### Cardinality
```mermaid
classDiagram
    Customer "1" --> "*" Order
    Order "1" *-- "1..*" LineItem
    Person "0..1" --> "0..1" Address
```

### Annotations
```mermaid
classDiagram
    class Shape {
        <<interface>>
        +draw()
    }

    class AbstractClass {
        <<abstract>>
        +method()
    }

    class Service {
        <<service>>
    }

    class MyEnum {
        <<enumeration>>
        VALUE1
        VALUE2
    }
```

## ER Diagram Syntax

### Entity Definition
```mermaid
erDiagram
    ENTITY {
        type attribute_name PK "comment"
        type attribute_name FK
        type attribute_name UK
    }
```

### Key Types
| Notation | Meaning |
|----------|---------|
| `PK` | Primary Key |
| `FK` | Foreign Key |
| `UK` | Unique Key |

### Relationship Cardinality
| Value | Meaning |
|-------|---------|
| `\|o` | Zero or one |
| `\|\|` | Exactly one |
| `}o` | Zero or more |
| `}\|` | One or more |

### Relationship Syntax
```
||--||    One to one
||--o{    One to zero or more
||--|{    One to one or more
}o--o{    Zero or more to zero or more
```

## State Diagram Syntax

### Basic States
```mermaid
stateDiagram-v2
    [*] --> State1
    State1 --> State2 : transition
    State2 --> [*]

    state "Long State Name" as LSN
```

### Composite States
```mermaid
stateDiagram-v2
    state Parent {
        [*] --> Child1
        Child1 --> Child2
        Child2 --> [*]
    }
```

### Special States
```mermaid
stateDiagram-v2
    state fork_state <<fork>>
    state join_state <<join>>
    state choice_state <<choice>>
```

### Notes
```mermaid
stateDiagram-v2
    State1 : Description
    note right of State1
        Multi-line
        note text
    end note
```

## Gantt Chart Syntax

### Task Definition
```
taskname :tag, start_date, duration
taskname :tag, after dependency, duration
taskname :done, 2024-01-01, 5d
taskname :active, after task1, 3d
taskname :crit, 2024-01-10, 1d
taskname :milestone, after task2, 0d
```

### Task States
| State | Meaning |
|-------|---------|
| `done` | Completed |
| `active` | In progress |
| `crit` | Critical path |
| (none) | Upcoming |

### Date Formats
```
dateFormat YYYY-MM-DD
dateFormat DD-MM-YYYY
axisFormat %Y-%m
```

## Comments

All diagram types support comments:
```mermaid
flowchart TD
    %% This is a comment
    A --> B
```

## Escaping Special Characters

```mermaid
flowchart TD
    A["Text with #quot;quotes#quot;"]
    B["Text with #lpar;parens#rpar;"]
    C["Line 1#br;Line 2"]
```

### Escape Sequences
| Sequence | Character |
|----------|-----------|
| `#quot;` | `"` |
| `#lpar;` | `(` |
| `#rpar;` | `)` |
| `#br;` | Line break |
| `#semi;` | `;` |
| `#colon;` | `:` |

## Accessibility

```mermaid
flowchart TD
    accTitle: Chart title for screen readers
    accDescr: Detailed description of the chart

    A --> B
```
