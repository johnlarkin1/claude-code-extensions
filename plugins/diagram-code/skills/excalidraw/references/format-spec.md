# Excalidraw Format Specification

Complete specification of the `.excalidraw` JSON file format.

## Table of Contents

1. [File Structure](#1-file-structure)
2. [Base Element Properties](#2-base-element-properties)
3. [Element Types](#3-element-types)
4. [Styling Reference](#4-styling-reference)
5. [Element Relationships](#5-element-relationships)
6. [Generation Guidelines](#6-generation-guidelines)

---

## 1. File Structure

Every `.excalidraw` file:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20,
    "gridStep": 5,
    "gridModeEnabled": false,
    "lockedMultiSelections": {}
  },
  "files": {}
}
```

### Files Object (Embedded Images)

```json
{
  "files": {
    "fileId123": {
      "id": "fileId123",
      "mimeType": "image/png",
      "dataURL": "data:image/png;base64,iVBORw0KGgo...",
      "created": 1705276800000
    }
  }
}
```

---

## 2. Base Element Properties

All elements share:

```json
{
  "id": "element_abc123",
  "type": "rectangle",
  "x": 100,
  "y": 100,
  "width": 200,
  "height": 150,
  "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "roundness": null,
  "seed": 1234567890,
  "version": 1,
  "versionNonce": 0,
  "updated": 1705276800000,
  "isDeleted": false,
  "locked": false,
  "groupIds": [],
  "frameId": null,
  "boundElements": null,
  "link": null,
  "index": "a0",
  "customData": {}
}
```

### Roundness

```json
"roundness": null                // No rounding
"roundness": { "type": 3 }       // Rounded corners (rectangles) - 32px
"roundness": { "type": 2 }       // Proportional (lines, arrows, diamonds) - 25%
```

---

## 3. Element Types

### Rectangle

```json
{
  "type": "rectangle",
  "id": "rect_001",
  "x": 100, "y": 100, "width": 200, "height": 100, "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "#a5d8ff",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "roundness": { "type": 3 },
  "seed": 1234567890,
  "version": 1,
  "versionNonce": 0,
  "isDeleted": false,
  "groupIds": [],
  "frameId": null,
  "boundElements": null,
  "updated": 1705276800000,
  "link": null,
  "locked": false,
  "index": "a0"
}
```

### Diamond

```json
{
  "type": "diamond",
  "roundness": { "type": 2 },
  // ... base properties
}
```

### Ellipse

```json
{
  "type": "ellipse",
  "roundness": null,
  // ... base properties
}
```

### Text

```json
{
  "type": "text",
  "id": "text_001",
  "x": 100, "y": 100, "width": 150, "height": 25, "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "roundness": null,
  "seed": 444555666,
  "version": 1,
  "versionNonce": 0,
  "isDeleted": false,
  "groupIds": [],
  "frameId": null,
  "boundElements": null,
  "updated": 1705276800000,
  "link": null,
  "locked": false,
  "index": "a1",
  "text": "Hello World",
  "originalText": "Hello World",
  "fontSize": 20,
  "fontFamily": 5,
  "textAlign": "left",
  "verticalAlign": "top",
  "containerId": null,
  "autoResize": true,
  "lineHeight": 1.25
}
```

### Line

```json
{
  "type": "line",
  "id": "line_001",
  "x": 100, "y": 100, "width": 200, "height": 100, "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "roundness": { "type": 2 },
  "seed": 777888999,
  "version": 1,
  "versionNonce": 0,
  "isDeleted": false,
  "groupIds": [],
  "frameId": null,
  "boundElements": null,
  "updated": 1705276800000,
  "link": null,
  "locked": false,
  "index": "a2",
  "points": [[0, 0], [200, 100]],
  "startBinding": null,
  "endBinding": null,
  "startArrowhead": null,
  "endArrowhead": null,
  "polygon": false
}
```

### Arrow

```json
{
  "type": "arrow",
  "id": "arrow_001",
  "x": 100, "y": 100, "width": 200, "height": 0, "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "roundness": { "type": 2 },
  "seed": 111333555,
  "version": 1,
  "versionNonce": 0,
  "isDeleted": false,
  "groupIds": [],
  "frameId": null,
  "boundElements": null,
  "updated": 1705276800000,
  "link": null,
  "locked": false,
  "index": "a3",
  "points": [[0, 0], [200, 0]],
  "startBinding": null,
  "endBinding": null,
  "startArrowhead": null,
  "endArrowhead": "arrow",
  "elbowed": false
}
```

### Freedraw

```json
{
  "type": "freedraw",
  "points": [[0, 0], [10, 5], [20, 8], ...],
  "pressures": [0.5, 0.6, 0.7, ...],
  "simulatePressure": true
  // ... base properties
}
```

### Image

```json
{
  "type": "image",
  "fileId": "fileId123",
  "status": "saved",
  "scale": [1, 1],
  "crop": null
  // ... base properties
}
```

### Frame

```json
{
  "type": "frame",
  "name": "My Frame"
  // ... base properties
}
```

---

## 4. Styling Reference

### Fill Styles

| Value | Description |
|-------|-------------|
| `"solid"` | Solid color fill |
| `"hachure"` | Diagonal line pattern |
| `"cross-hatch"` | Cross pattern fill |
| `"zigzag"` | Zigzag pattern fill |

### Stroke Styles

| Value | Description |
|-------|-------------|
| `"solid"` | Continuous line |
| `"dashed"` | Dashed line |
| `"dotted"` | Dotted line |

### Font Families

| ID | Font Name |
|----|-----------|
| `1` | Virgil (hand-drawn) |
| `2` | Helvetica |
| `3` | Cascadia (monospace) |
| `5` | Excalifont (default) |
| `6` | Nunito |
| `7` | Lilita One |
| `8` | Comic Shanns |

### Arrowhead Types

| Value | Description |
|-------|-------------|
| `null` | No arrowhead |
| `"arrow"` | Standard arrow |
| `"bar"` | Perpendicular bar |
| `"circle"` | Filled circle |
| `"circle_outline"` | Hollow circle |
| `"triangle"` | Filled triangle |
| `"triangle_outline"` | Hollow triangle |
| `"diamond"` | Filled diamond |
| `"diamond_outline"` | Hollow diamond |
| `"crowfoot_one"` | ERD: one |
| `"crowfoot_many"` | ERD: many |
| `"crowfoot_one_or_many"` | ERD: one or many |

### Common Colors

**Stroke:**
- `"#1e1e1e"` - Black (default)
- `"#e03131"` - Red
- `"#2f9e44"` - Green
- `"#1971c2"` - Blue
- `"#f08c00"` - Orange

**Background:**
- `"transparent"`
- `"#ffffff"` - White
- `"#a5d8ff"` - Light blue
- `"#b2f2bb"` - Light green
- `"#ffec99"` - Light yellow
- `"#ffc9c9"` - Light red
- `"#d0bfff"` - Light purple

---

## 5. Element Relationships

### Arrow Bindings

**CRITICAL: Update both sides!**

Arrow binding structure:
```json
{
  "startBinding": {
    "elementId": "rect_001",
    "fixedPoint": [1.0, 0.5001],
    "mode": "orbit"
  },
  "endBinding": {
    "elementId": "rect_002",
    "fixedPoint": [0.0, 0.5001],
    "mode": "orbit"
  }
}
```

Shape must also reference the arrow:
```json
{
  "type": "rectangle",
  "id": "rect_001",
  "boundElements": [
    { "id": "arrow_001", "type": "arrow" }
  ]
}
```

**fixedPoint reference:**
```
      0.0   0.5   1.0  (x ratio)
       │     │     │
  0.0 ─┼─────┼─────┼─  Top edge
       │           │
  0.5 ─┼     ●     ┼─  Center
       │           │
  1.0 ─┼─────┼─────┼─  Bottom edge
```

### Text Containers

```json
// Container shape
{
  "type": "rectangle",
  "id": "rect_001",
  "boundElements": [{ "id": "text_001", "type": "text" }]
}

// Bound text
{
  "type": "text",
  "id": "text_001",
  "containerId": "rect_001",
  "textAlign": "center",
  "verticalAlign": "middle"
}
```

### Groups

Elements in nested groups:
```json
{
  "groupIds": ["group_inner", "group_outer"]
  // Ordered: deepest first
}
```

### Frames

```json
// Element inside frame
{
  "frameId": "frame_001"
}
```

---

## 6. Generation Guidelines

### ID Generation

Use unique IDs:
- Sequential: `"rect_001"`, `"arrow_002"`
- UUID: `crypto.randomUUID()`
- Nanoid style: `"V1StGXR8_Z5jdHi6B"`

### Seed

Random integer for hand-drawn effect:
```javascript
Math.floor(Math.random() * 2147483647)
```

### Timestamp

Milliseconds since epoch:
```javascript
Date.now()  // e.g., 1705276800000
```

### Index (Fractional Ordering)

- First: `"a0"`
- Subsequent: `"a1"`, `"a2"`, etc.
- Between a0 and a1: `"a0V"`

### Width/Height for Lines

Calculate from points:
```javascript
width = Math.max(...points.map(p => p[0])) - Math.min(...points.map(p => p[0]));
height = Math.max(...points.map(p => p[1])) - Math.min(...points.map(p => p[1]));
```

### Required Properties by Type

**All elements:** id, type, x, y, width, height, angle, strokeColor, backgroundColor, fillStyle, strokeWidth, strokeStyle, roughness, opacity, roundness, seed, version, versionNonce, isDeleted, updated, groupIds, frameId, boundElements, link, locked, index

**Text:** text, originalText, fontSize, fontFamily, textAlign, verticalAlign, containerId, autoResize, lineHeight

**Line/Arrow:** points, startBinding, endBinding, startArrowhead, endArrowhead

**Arrow only:** elbowed

**Line only:** polygon

**Image:** fileId, status, scale

**Frame:** name

**Freedraw:** points, pressures, simulatePressure
