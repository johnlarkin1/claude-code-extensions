---
name: graphviz
description: Generate GraphViz DOT files (.dot) for directed/undirected graphs, hierarchical layouts, network diagrams, dependency graphs, state machines, and complex graph visualizations. Use when precise node positioning is needed, when rendering to PNG/SVG/PDF is required, when complex graph algorithms (clustering, ranking) are needed, or when dealing with large graphs (100+ nodes). Triggers on requests mentioning GraphViz, DOT language, network diagrams, dependency graphs, or when sophisticated graph layout is required.
tools: Read, Write, Bash
---

# GraphViz DOT Generation

Generate graph descriptions using DOT language. GraphViz provides powerful automatic layout algorithms for complex graphs.

## Quick Start

Minimal directed graph:
```dot
digraph G {
    A -> B -> C;
}
```

## Output Formats

1. **DOT file** - `.dot` extension for source
2. **Rendered images** - Use Bash to render:
   ```bash
   dot -Tpng graph.dot -o graph.png
   dot -Tsvg graph.dot -o graph.svg
   dot -Tpdf graph.dot -o graph.pdf
   ```

## Workflow

1. **Choose graph type** - `digraph` (directed) or `graph` (undirected)
2. **Define structure** - Nodes and edges
3. **Apply attributes** - Styling and layout hints
4. **Write file** - Save as `.dot`
5. **Render** (optional) - Convert to image format

## Graph Types

### Directed Graph (digraph)
```dot
digraph ProcessFlow {
    rankdir=LR;

    start [shape=circle, style=filled, fillcolor=green];
    end [shape=doublecircle, style=filled, fillcolor=red];

    start -> process1 -> decision;
    decision -> process2 [label="yes"];
    decision -> process3 [label="no"];
    process2 -> end;
    process3 -> end;
}
```

### Undirected Graph (graph)
```dot
graph Network {
    layout=neato;
    overlap=false;

    server [shape=box3d];
    client1 -- server;
    client2 -- server;
    client3 -- server;
    client1 -- client2 [style=dashed];
}
```

## Common Patterns

### Hierarchical Layout (Default)
```dot
digraph Hierarchy {
    rankdir=TB;
    node [shape=box];

    CEO -> {VP1, VP2, VP3};
    VP1 -> {M1, M2};
    VP2 -> {M3, M4};
    VP3 -> {M5, M6};
}
```

### Dependency Graph
```dot
digraph Dependencies {
    rankdir=LR;
    node [shape=box, style=rounded];

    app -> {libA, libB, libC};
    libA -> {libD, libE};
    libB -> libD;
    libC -> libE;
}
```

### State Machine
```dot
digraph StateMachine {
    rankdir=LR;
    node [shape=circle];

    start [shape=point];
    end [shape=doublecircle];

    start -> idle;
    idle -> running [label="start"];
    running -> paused [label="pause"];
    paused -> running [label="resume"];
    running -> idle [label="stop"];
    idle -> end [label="exit"];
}
```

### Network Topology
```dot
graph Topology {
    layout=fdp;
    overlap=false;
    splines=true;

    subgraph cluster_dc1 {
        label="Data Center 1";
        style=dashed;
        router1 [shape=box3d];
        server1a, server1b;
    }

    subgraph cluster_dc2 {
        label="Data Center 2";
        style=dashed;
        router2 [shape=box3d];
        server2a, server2b;
    }

    internet [shape=cloud];

    router1 -- server1a;
    router1 -- server1b;
    router2 -- server2a;
    router2 -- server2b;
    router1 -- internet;
    router2 -- internet;
}
```

### Record-Based Nodes (Structs)
```dot
digraph Structs {
    node [shape=record];

    struct1 [label="{Name|{Field1|Field2|Field3}}"];
    struct2 [label="{<f0>Head|{<f1>Left|<f2>Right}}"];

    struct2:f1 -> struct1;
    struct2:f2 -> struct1;
}
```

## Node Shapes

| Shape | Use Case |
|-------|----------|
| `box` | Process, component |
| `ellipse` | Default, general |
| `circle` | State, small node |
| `doublecircle` | Final state |
| `diamond` | Decision |
| `record` | Data structure |
| `Mrecord` | Rounded record |
| `box3d` | Server, database |
| `cylinder` | Database |
| `folder` | Directory |
| `note` | Comment |
| `tab` | Tab/window |
| `house` | Home/start |
| `invhouse` | Inverted house |
| `polygon` | Custom (sides=N) |
| `point` | Tiny/start point |
| `plaintext` | Text only |

## Edge Attributes

```dot
digraph Edges {
    A -> B [label="labeled"];
    A -> C [style=dashed];
    A -> D [style=dotted];
    A -> E [style=bold];
    A -> F [color=red];
    A -> G [penwidth=3];
    A -> H [arrowhead=none];
    A -> I [arrowhead=diamond];
    A -> J [dir=both];
    A -> K [constraint=false];  // Don't affect rank
}
```

## Subgraphs and Clusters

```dot
digraph Clusters {
    subgraph cluster_0 {
        label="Cluster A";
        style=filled;
        color=lightgrey;
        a0 -> a1 -> a2;
    }

    subgraph cluster_1 {
        label="Cluster B";
        color=blue;
        b0 -> b1 -> b2;
    }

    a2 -> b0;
}
```

Note: Subgraphs named `cluster_*` are drawn as boxes.

## Layout Engines

| Engine | Use Case |
|--------|----------|
| `dot` | Hierarchical (default) |
| `neato` | Spring model, undirected |
| `fdp` | Force-directed |
| `sfdp` | Large graph force-directed |
| `circo` | Circular layout |
| `twopi` | Radial layout |

Select via:
```dot
digraph G {
    layout=neato;
    // or use command: neato -Tpng graph.dot -o graph.png
}
```

## Rendering Commands

```bash
# Basic PNG
dot -Tpng input.dot -o output.png

# SVG for web
dot -Tsvg input.dot -o output.svg

# PDF for documents
dot -Tpdf input.dot -o output.pdf

# High-resolution PNG
dot -Tpng -Gdpi=300 input.dot -o output.png

# Using different layout engine
neato -Tpng input.dot -o output.png
fdp -Tpng input.dot -o output.png

# Validate syntax
dot -Tcanon input.dot

# Debug layout
dot -v input.dot
```

## Critical Rules

1. **Semicolons** - Optional but recommended for clarity
2. **Quotes** - Use for labels with spaces/special chars
3. **IDs** - No spaces, or use quotes: `"Node Name"`
4. **Attributes** - In square brackets: `[attr=value]`
5. **Cluster naming** - Must start with `cluster_` to be boxed
6. **Edge syntax** - `->` for digraph, `--` for graph

## When to Use GraphViz

- Complex dependency graphs
- Large graphs with many nodes
- Network topology diagrams
- State machines and automata
- When precise layout control is needed
- When rendering to image files is required
- Hierarchical structures (org charts, trees)
- When automatic layout is preferred over manual

## References

See `references/dot-syntax.md` for complete attribute reference.
See `references/layout-engines.md` for detailed layout engine comparison.
