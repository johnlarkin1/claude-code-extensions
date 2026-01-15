# GraphViz Layout Engines Reference

Detailed comparison and usage guide for GraphViz layout algorithms.

## Engine Overview

| Engine | Type | Best For |
|--------|------|----------|
| `dot` | Hierarchical | DAGs, trees, flowcharts |
| `neato` | Spring model | Small undirected graphs |
| `fdp` | Force-directed | Undirected graphs, clusters |
| `sfdp` | Scalable force-directed | Large undirected graphs |
| `circo` | Circular | Cyclic structures, rings |
| `twopi` | Radial | Root-centered trees |
| `patchwork` | Squarified treemap | Hierarchical data |
| `osage` | Array-based | Recursive clusters |

## dot - Hierarchical Layout

Default engine for directed graphs. Creates layered layouts.

### Best For
- Flowcharts
- Dependency graphs
- Trees and hierarchies
- State machines
- Call graphs

### Key Attributes
```dot
digraph G {
    graph [
        rankdir=TB,      // TB, BT, LR, RL
        ranksep=0.5,     // Space between ranks
        nodesep=0.25     // Space between nodes in rank
    ];

    A -> B -> C;
}
```

### Rank Control
```dot
digraph G {
    { rank=same; B; C; D; }   // Force same level
    { rank=min; Start; }       // Force to top
    { rank=max; End; }         // Force to bottom

    Start -> A -> {B, C, D} -> End;
}
```

### Example
```dot
digraph Workflow {
    rankdir=LR;
    node [shape=box];

    subgraph cluster_input {
        label="Input";
        raw [label="Raw Data"];
    }

    subgraph cluster_process {
        label="Processing";
        validate -> transform -> enrich;
    }

    subgraph cluster_output {
        label="Output";
        store [label="Database"];
        api [label="API"];
    }

    raw -> validate;
    enrich -> store;
    enrich -> api;
}
```

### Command
```bash
dot -Tpng input.dot -o output.png
```

---

## neato - Spring Model

Uses stress majorization for undirected graphs.

### Best For
- Undirected graphs
- Network diagrams
- Small to medium graphs (<100 nodes)
- When edge length matters

### Key Attributes
```dot
graph G {
    graph [
        layout=neato,
        overlap=false,   // Prevent node overlap
        sep="+10",       // Separation margin
        splines=true     // Curved edges
    ];

    A -- B -- C;
    A -- C;
}
```

### Edge Length Control
```dot
graph G {
    layout=neato;

    // Default edge length
    A -- B;

    // Longer edge
    A -- C [len=3];

    // Shorter edge
    B -- C [len=0.5];
}
```

### Example
```dot
graph Network {
    layout=neato;
    overlap=false;
    splines=true;

    node [shape=circle, style=filled, fillcolor=lightblue];

    // Hub
    hub [shape=doublecircle, fillcolor=yellow];

    // Connections
    hub -- {A, B, C, D, E};
    A -- B;
    B -- C;
    D -- E;
}
```

### Command
```bash
neato -Tpng input.dot -o output.png
# or: dot -Kneato -Tpng input.dot -o output.png
```

---

## fdp - Force-Directed Placement

Spring model with multi-scale approach. Better cluster support than neato.

### Best For
- Undirected graphs with clusters
- Medium-sized graphs
- When natural clustering is important

### Key Attributes
```dot
graph G {
    graph [
        layout=fdp,
        overlap=false,
        K=0.6,           // Ideal edge length
        maxiter=1000,    // Iterations
        start=random     // Initial placement
    ];

    A -- B -- C;
}
```

### Cluster Support
```dot
graph G {
    layout=fdp;
    overlap=false;

    subgraph cluster_0 {
        label="Group A";
        a1 -- a2 -- a3;
    }

    subgraph cluster_1 {
        label="Group B";
        b1 -- b2 -- b3;
    }

    a2 -- b2;
}
```

### Example
```dot
graph Modules {
    layout=fdp;
    overlap=prism;
    splines=true;

    subgraph cluster_core {
        label="Core";
        style=filled;
        fillcolor=lightgrey;
        core1 -- core2 -- core3;
        core1 -- core3;
    }

    subgraph cluster_ui {
        label="UI";
        ui1 -- ui2;
    }

    subgraph cluster_data {
        label="Data";
        data1 -- data2;
    }

    core1 -- ui1;
    core2 -- data1;
}
```

### Command
```bash
fdp -Tpng input.dot -o output.png
```

---

## sfdp - Scalable Force-Directed

Optimized for large graphs (1000+ nodes).

### Best For
- Large graphs
- Social networks
- Web graphs
- When fdp is too slow

### Key Attributes
```dot
graph G {
    graph [
        layout=sfdp,
        overlap=prism,   // Best overlap removal
        overlap_scaling=-3,
        splines=true,
        K=2              // Edge length scale
    ];
}
```

### Example
```dot
graph Large {
    layout=sfdp;
    overlap=prism;

    // Generate with many nodes
    node [shape=point];

    // sfdp handles this efficiently
    1 -- {2, 3, 4, 5};
    2 -- {6, 7, 8};
    3 -- {9, 10, 11};
    // ... many more
}
```

### Command
```bash
sfdp -Tpng input.dot -o output.png
```

---

## circo - Circular Layout

Arranges nodes in a circle.

### Best For
- Cyclic graphs
- Ring topologies
- Circular dependencies
- Round-robin relationships

### Key Attributes
```dot
digraph G {
    graph [
        layout=circo,
        mindist=1.5      // Minimum node distance
    ];

    A -> B -> C -> D -> A;
}
```

### Example
```dot
digraph Ring {
    layout=circo;

    node [shape=circle, style=filled, fillcolor=lightblue];

    // Ring structure
    n1 -> n2 -> n3 -> n4 -> n5 -> n6 -> n1;

    // Central hub
    hub [fillcolor=yellow];
    hub -> {n1, n3, n5};
}
```

### Command
```bash
circo -Tpng input.dot -o output.png
```

---

## twopi - Radial Layout

Nodes placed in concentric circles around a root.

### Best For
- Trees with central root
- Organizational hierarchies viewed radially
- Network with central server

### Key Attributes
```dot
graph G {
    graph [
        layout=twopi,
        root=center,     // Specify center node
        ranksep=2        // Ring separation
    ];

    center -- {A, B, C, D};
}
```

### Example
```dot
graph Radial {
    layout=twopi;
    ranksep=1.5;
    root=core;

    node [shape=circle];

    // Center
    core [style=filled, fillcolor=red, fontcolor=white];

    // First ring
    core -- {L1a, L1b, L1c, L1d};

    // Second ring
    L1a -- {L2a, L2b};
    L1b -- {L2c, L2d};
    L1c -- {L2e, L2f};
    L1d -- {L2g, L2h};
}
```

### Command
```bash
twopi -Tpng input.dot -o output.png
```

---

## patchwork - Treemap Layout

Squarified treemap for hierarchical data.

### Best For
- Showing proportional sizes
- Disk usage visualization
- Portfolio allocation

### Example
```dot
digraph Treemap {
    layout=patchwork;

    node [style=filled];

    // Areas determine by edge weights or node sizes
    root -> {A, B, C};
    A [area=10, fillcolor=red];
    B [area=20, fillcolor=blue];
    C [area=15, fillcolor=green];
}
```

---

## osage - Recursive Cluster Packing

Pack clusters recursively.

### Best For
- Visualizing nested structures
- Organizational layouts

### Example
```dot
digraph G {
    layout=osage;

    subgraph cluster_0 {
        subgraph cluster_0_0 {
            a; b;
        }
        subgraph cluster_0_1 {
            c; d;
        }
    }

    subgraph cluster_1 {
        e; f; g;
    }
}
```

---

## Choosing the Right Engine

```
START
  |
  v
Is the graph directed with hierarchy?
  |-- Yes --> Use DOT
  |
  No
  |
  v
Is it a circular/ring structure?
  |-- Yes --> Use CIRCO
  |
  No
  |
  v
Is there a central root node?
  |-- Yes --> Use TWOPI
  |
  No
  |
  v
Does the graph have clusters?
  |-- Yes --> Use FDP
  |
  No
  |
  v
Is the graph large (>1000 nodes)?
  |-- Yes --> Use SFDP
  |
  No
  |
  v
Use NEATO (general spring model)
```

## Command-Line Usage

### Basic Rendering
```bash
# Using engine name as command
dot -Tpng graph.dot -o output.png
neato -Tpng graph.dot -o output.png
fdp -Tpng graph.dot -o output.png

# Using -K flag with dot
dot -Kneato -Tpng graph.dot -o output.png
dot -Kfdp -Tpng graph.dot -o output.png
```

### Common Options
```bash
-T<format>     Output format (png, svg, pdf, ps, eps)
-o <file>      Output file
-G<attr>=<val> Set graph attribute
-N<attr>=<val> Set default node attribute
-E<attr>=<val> Set default edge attribute
-Gdpi=300      Set resolution
-v             Verbose output
```

### Batch Processing
```bash
# Convert all .dot files to PNG
for f in *.dot; do
    dot -Tpng "$f" -o "${f%.dot}.png"
done

# Try different layouts
for engine in dot neato fdp circo twopi; do
    $engine -Tpng graph.dot -o "graph_$engine.png"
done
```

## Performance Tips

1. **Large graphs**: Use sfdp instead of neato/fdp
2. **Overlap**: Use `overlap=prism` for best results
3. **Splines**: Set `splines=false` for faster rendering
4. **Simplify**: Remove unnecessary attributes during development
5. **Clusters**: fdp handles clusters better than neato
