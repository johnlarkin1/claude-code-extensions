# Mermaid Diagram Types Reference

Complete examples for all Mermaid diagram types.

## Flowchart

### Basic Flowchart
```mermaid
flowchart TD
    A[Start] --> B[Process 1]
    B --> C{Decision}
    C -->|Yes| D[Process 2]
    C -->|No| E[Process 3]
    D --> F[End]
    E --> F
```

### Horizontal Flowchart
```mermaid
flowchart LR
    Input[/Input Data/] --> Process[Process]
    Process --> Output[/Output/]
    Process --> Database[(Database)]
```

### Complex Flowchart with Subgraphs
```mermaid
flowchart TB
    subgraph Frontend
        A[React App] --> B[Components]
        B --> C[State Management]
    end

    subgraph Backend
        D[API Server] --> E[Controllers]
        E --> F[Services]
        F --> G[(Database)]
    end

    C --> D
```

### All Node Shapes
```mermaid
flowchart TD
    A[Rectangle] --> B(Rounded)
    B --> C([Stadium])
    C --> D[[Subroutine]]
    D --> E[(Database)]
    E --> F((Circle))
    F --> G{Diamond}
    G --> H{{Hexagon}}
    H --> I[/Parallelogram/]
    I --> J[\Parallelogram Alt\]
    J --> K[/Trapezoid\]
    K --> L[\Trapezoid Alt/]
```

### All Arrow Types
```mermaid
flowchart LR
    A --> B
    B --- C
    C -.-> D
    D ==> E
    E --text--> F
    F -.text.-> G
    G ==text==> H
    H <--> I
    I o--o J
    J x--x K
```

## Sequence Diagram

### Basic Sequence
```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server
    participant DB as Database

    C->>S: HTTP Request
    activate S
    S->>DB: Query
    activate DB
    DB-->>S: Results
    deactivate DB
    S-->>C: HTTP Response
    deactivate S
```

### With Loops and Alternatives
```mermaid
sequenceDiagram
    participant U as User
    participant A as Auth Service
    participant API as API Server

    U->>A: Login Request

    alt Valid Credentials
        A-->>U: JWT Token
        U->>API: Request + Token

        loop Retry on Failure
            API->>API: Process
        end

        API-->>U: Response
    else Invalid Credentials
        A-->>U: Error 401
    end
```

### With Notes and Participants
```mermaid
sequenceDiagram
    autonumber

    actor User
    participant FE as Frontend
    participant BE as Backend
    participant Cache as Redis

    Note over User,Cache: Authentication Flow

    User->>FE: Enter Credentials
    FE->>BE: POST /login

    Note right of BE: Validate credentials

    BE->>Cache: Check session
    Cache-->>BE: Session data
    BE-->>FE: JWT Token
    FE-->>User: Redirect to Dashboard

    Note over FE,BE: Token valid for 24h
```

## Class Diagram

### Basic Class Diagram
```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound() void
        +move() void
    }

    class Dog {
        +String breed
        +bark() void
        +fetch() void
    }

    class Cat {
        +bool indoor
        +meow() void
        +scratch() void
    }

    Animal <|-- Dog : inherits
    Animal <|-- Cat : inherits
```

### With Relationships
```mermaid
classDiagram
    class Order {
        +int orderId
        +Date orderDate
        +calculateTotal() float
    }

    class Customer {
        +String name
        +String email
        +placeOrder() Order
    }

    class Product {
        +String name
        +float price
    }

    class LineItem {
        +int quantity
        +getSubtotal() float
    }

    Customer "1" --> "*" Order : places
    Order "1" *-- "*" LineItem : contains
    LineItem "*" --> "1" Product : references
```

### Relationship Types
```mermaid
classDiagram
    classA --|> classB : Inheritance
    classC --* classD : Composition
    classE --o classF : Aggregation
    classG --> classH : Association
    classI -- classJ : Link (Solid)
    classK ..> classL : Dependency
    classM ..|> classN : Realization
    classO .. classP : Link (Dashed)
```

## Entity Relationship Diagram

### Database Schema
```mermaid
erDiagram
    USER {
        int id PK
        string email UK
        string name
        datetime created_at
    }

    ORDER {
        int id PK
        int user_id FK
        datetime order_date
        string status
        float total
    }

    PRODUCT {
        int id PK
        string name
        float price
        int stock
    }

    ORDER_ITEM {
        int id PK
        int order_id FK
        int product_id FK
        int quantity
        float unit_price
    }

    USER ||--o{ ORDER : "places"
    ORDER ||--|{ ORDER_ITEM : "contains"
    PRODUCT ||--o{ ORDER_ITEM : "included in"
```

### Cardinality Notation
```mermaid
erDiagram
    A ||--|| B : "one to one"
    C ||--o{ D : "one to zero or more"
    E ||--|{ F : "one to one or more"
    G }o--o{ H : "zero or more to zero or more"
```

## State Diagram

### Basic State Machine
```mermaid
stateDiagram-v2
    [*] --> Idle

    Idle --> Processing : submit
    Processing --> Success : complete
    Processing --> Error : fail

    Success --> [*]
    Error --> Idle : retry
    Error --> [*] : cancel
```

### With Composite States
```mermaid
stateDiagram-v2
    [*] --> Active

    state Active {
        [*] --> Idle
        Idle --> Running : start
        Running --> Paused : pause
        Paused --> Running : resume
        Running --> Idle : stop
    }

    Active --> Terminated : shutdown
    Terminated --> [*]
```

### With Forks and Joins
```mermaid
stateDiagram-v2
    [*] --> Init

    state fork_state <<fork>>
    Init --> fork_state
    fork_state --> Task1
    fork_state --> Task2
    fork_state --> Task3

    state join_state <<join>>
    Task1 --> join_state
    Task2 --> join_state
    Task3 --> join_state
    join_state --> Complete

    Complete --> [*]
```

## Gantt Chart

### Project Timeline
```mermaid
gantt
    title Project Development Timeline
    dateFormat YYYY-MM-DD

    section Planning
    Requirements Analysis    :a1, 2024-01-01, 14d
    Technical Design        :a2, after a1, 10d

    section Development
    Backend Development     :b1, after a2, 30d
    Frontend Development    :b2, after a2, 25d
    API Integration         :b3, after b1, 10d

    section Testing
    Unit Testing           :c1, after b2, 7d
    Integration Testing    :c2, after b3, 7d
    UAT                    :c3, after c2, 5d

    section Deployment
    Staging Deploy         :d1, after c3, 2d
    Production Deploy      :milestone, after d1, 0d
```

### With Task States
```mermaid
gantt
    title Sprint Planning
    dateFormat YYYY-MM-DD

    section Completed
    Task A :done, a1, 2024-01-01, 5d
    Task B :done, a2, after a1, 3d

    section In Progress
    Task C :active, a3, after a2, 4d

    section Upcoming
    Task D :a4, after a3, 5d
    Task E :crit, a5, after a4, 3d
```

## Pie Chart

### Simple Distribution
```mermaid
pie showData
    title Browser Market Share
    "Chrome" : 65
    "Safari" : 19
    "Firefox" : 8
    "Edge" : 5
    "Other" : 3
```

## Mindmap

### Hierarchical Ideas
```mermaid
mindmap
    root((Project Planning))
        Requirements
            Functional
                User Stories
                Use Cases
            Non-Functional
                Performance
                Security
        Design
            Architecture
                Frontend
                Backend
            Database
                Schema
                Migrations
        Implementation
            Sprint 1
            Sprint 2
            Sprint 3
        Testing
            Unit Tests
            Integration
            E2E
```

## Timeline

### Historical Events
```mermaid
timeline
    title Company History
    section Founding
        2018 : Company founded
             : Initial funding round
    section Growth
        2019 : Series A
             : 50 employees
        2020 : International expansion
        2021 : Series B
             : 200 employees
    section Present
        2022 : IPO
        2023 : Acquisitions
```

## Git Graph

### Branch Management
```mermaid
gitGraph
    commit id: "Initial"
    branch develop
    checkout develop
    commit id: "Feature A start"
    commit id: "Feature A complete"
    checkout main
    merge develop id: "Merge Feature A"

    branch feature-b
    checkout feature-b
    commit id: "Feature B start"

    checkout develop
    commit id: "Hotfix"

    checkout feature-b
    commit id: "Feature B complete"

    checkout develop
    merge feature-b id: "Merge Feature B"

    checkout main
    merge develop id: "Release v1.0" tag: "v1.0"
```

## Quadrant Chart

### Priority Matrix
```mermaid
quadrantChart
    title Priority Matrix
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Do First
    quadrant-2 Schedule
    quadrant-3 Delegate
    quadrant-4 Eliminate

    Task A: [0.8, 0.9]
    Task B: [0.2, 0.8]
    Task C: [0.7, 0.3]
    Task D: [0.3, 0.2]
```
