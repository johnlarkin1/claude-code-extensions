# Manim API Reference

## 1. Animation Classes (60+)

### Base
- **Animation**: Base class for all animations
- **Add**: Add mobject without animation
- **Wait**: Wait for duration

### Creation
- **Create**: Draw object as if drawing it
- **Uncreate**: Reverse of Create
- **Write**: Text typing animation
- **Unwrite**: Reverse of Write
- **DrawBorderThenFill**: Draw border, then fill
- **SpiralIn**: Spiral in from center
- **ShowIncreasingSubsets**: Show submobjects incrementally
- **AddTextLetterByLetter**: Add text letter by letter
- **AddTextWordByWord**: Add text word by word
- **TypeWithCursor**: Simulate typing with cursor

### Fading
- **FadeIn**: Fade object in
- **FadeOut**: Fade object out

### Transform
- **Transform**: Morph obj1 into obj2
- **ReplacementTransform**: Transform and remove original
- **TransformFromCopy**: Transform from copy
- **ClockwiseTransform**: Transform clockwise
- **CounterclockwiseTransform**: Transform counterclockwise
- **MoveToTarget**: Move to previously set target
- **ApplyMethod**: Apply method during animation
- **ApplyFunction**: Apply transformation function
- **ApplyMatrix**: Apply matrix transformation
- **FadeToColor**: Fade to specific color
- **ScaleInPlace**: Scale keeping center fixed
- **ShrinkToCenter**: Shrink toward center
- **Restore**: Restore to previous state
- **FadeTransform**: Fade between mobjects while transforming

### Indication
- **Indicate**: Highlight with pulse/scaling
- **Flash**: Brief flash effect
- **ShowPassingFlash**: Moving flash across object
- **Circumscribe**: Draw border around object
- **Wiggle**: Wiggle back and forth
- **Blink**: Quick fade in/out
- **FocusOn**: Focus camera on mobject/point
- **ApplyWave**: Apply wave transformation

### Growth
- **GrowFromPoint**: Grow from specific point
- **GrowFromCenter**: Grow from center
- **GrowFromEdge**: Grow from edge
- **GrowArrow**: Growth for arrows
- **SpinInFromNothing**: Spin in from nothing

### Movement
- **Homotopy**: Continuous deformation
- **PhaseFlow**: Move according to phase flow
- **MoveAlongPath**: Move along specified path

### Rotation
- **Rotate**: Rotate by angle
- **Rotating**: Continuously rotate

### Numerical
- **ChangingDecimal**: Animate decimal changes
- **ChangeDecimalToValue**: Change decimal to target

### Composition
- **AnimationGroup**: Play animations together
- **Succession**: Play in sequence
- **LaggedStart**: Staggered start times
- **LaggedStartMap**: Map with lagged starts

### Transform Matching
- **TransformMatchingShapes**: Transform based on matching shapes
- **TransformMatchingTex**: Transform based on matching TeX

---

## 2. Mobject Classes (100+)

### Base Classes
- **Mobject**: Base class for all objects
- **VMobject**: Vector-based mobject for smooth curves
- **VGroup**: Group container for mobjects
- **VDict**: Dictionary-like container

### Geometry - Lines/Arrows
- **Line**: Line between two points
- **DashedLine**: Dashed line
- **TangentLine**: Tangent to curve
- **Arrow**: Line with arrowhead
- **Vector**: Vector from origin
- **DoubleArrow**: Arrow with heads at both ends
- **Elbow**: Corner/elbow shape
- **CurvedArrow**: Curved arrow
- **CurvedDoubleArrow**: Curved double arrow

### Geometry - Circles/Arcs
- **Circle**: Complete circle
- **Arc**: Circular arc
- **ArcBetweenPoints**: Arc connecting two points
- **Dot**: Small dot
- **AnnotationDot**: Dot with annotation
- **LabeledDot**: Dot with label
- **Ellipse**: Elliptical shape
- **CubicBezier**: Cubic Bezier curve

### Geometry - Angles
- **Angle**: Angle shape
- **RightAngle**: Right angle shape

### Geometry - Sectors
- **Sector**: Circle sector
- **AnnularSector**: Annulus sector
- **Annulus**: Ring shape

### Geometry - Polygons
- **Polygon**: Polygon from points
- **RegularPolygon**: Regular n-sided polygon
- **Triangle**: Equilateral triangle
- **Rectangle**: Rectangle
- **Square**: Square
- **RoundedRectangle**: Rectangle with rounded corners
- **Star**: Star shape

### Geometry - Arc Polygons
- **ArcPolygon**: Polygon with curved sides
- **ArcPolygonFromArcs**: Arc polygon from individual arcs

### Geometry - Boolean Operations
- **Union**: Union of shapes
- **Difference**: Difference of shapes
- **Intersection**: Intersection of shapes
- **Exclusion**: XOR of shapes

### Geometry - Labeled
- **Label**: Label for objects
- **LabeledLine**: Line with label
- **LabeledArrow**: Arrow with label

### Text
- **Text**: General text using fonts
- **MarkupText**: Text with markup styling
- **Paragraph**: Multiple lines of text
- **MathTex**: LaTeX math expression
- **Tex**: General TeX text
- **BulletedList**: Bulleted list
- **Title**: Title text
- **Code**: Source code with syntax highlighting

### Numerical Text
- **DecimalNumber**: Animatable decimal
- **Integer**: Integer number
- **Variable**: Variable with updatable value

### Graphing - Coordinate Systems
- **Axes**: 2D coordinate axes
- **ThreeDAxes**: 3D coordinate axes
- **NumberPlane**: Gridded plane
- **PolarPlane**: Polar coordinates
- **ComplexPlane**: Complex number plane

### Graphing - Functions
- **ParametricFunction**: Parametric curve
- **FunctionGraph**: Graph of y=f(x)
- **ImplicitFunction**: Implicit function graph

### Graphing - Special
- **NumberLine**: 1D number line
- **UnitInterval**: Number line 0 to 1
- **BarChart**: Bar chart
- **SampleSpace**: Probability rectangle

### Graph Theory
- **Graph**: Network graph
- **DiGraph**: Directed graph

### 3D Objects
- **ThreeDVMobject**: Base 3D vector mobject
- **Sphere**: 3D sphere
- **Cube**: 3D cube
- **Prism**: 3D prism
- **Cone**: 3D cone
- **Cylinder**: 3D cylinder
- **Torus**: 3D torus
- **Line3D**: 3D line
- **Arrow3D**: 3D arrow
- **Dot3D**: 3D dot
- **Surface**: 3D surface

### 3D Polyhedra
- **Polyhedron**: 3D polyhedron
- **Tetrahedron**: Regular tetrahedron
- **Octahedron**: Regular octahedron
- **Icosahedron**: Regular icosahedron
- **Dodecahedron**: Regular dodecahedron

### Tables
- **Table**: Data table
- **MathTable**: Table with math expressions
- **MobjectTable**: Table of mobjects
- **IntegerTable**: Table of integers
- **DecimalTable**: Table of decimals

### Matrices
- **Matrix**: Math matrix
- **DecimalMatrix**: Decimal matrix
- **IntegerMatrix**: Integer matrix
- **MobjectMatrix**: Mobject matrix

### Vector Fields
- **VectorField**: Vector field
- **ArrowVectorField**: Vector field with arrows
- **StreamLines**: Stream lines

### Value Tracking
- **ValueTracker**: Track numerical value for animations
- **ComplexValueTracker**: Track complex number

### SVG/Images
- **SVGMobject**: Create from SVG file
- **ImageMobject**: Display raster image

### Braces
- **Brace**: Brace annotation
- **BraceBetweenPoints**: Brace between two points
- **ArcBrace**: Arc-following brace
- **BraceLabel**: Brace with label

### Arrow Tips
- **ArrowTip**: Base arrow tip
- **StealthTip**: Sleek tip
- **ArrowTriangleTip**: Triangular tip
- **ArrowCircleTip**: Circular tip
- **ArrowSquareTip**: Square tip

---

## 3. Scene Classes

- **Scene**: Base scene for all animations
- **ThreeDScene**: Scene for 3D animations
- **SpecialThreeDScene**: Extended 3D features
- **MovingCameraScene**: Camera can move/pan
- **ZoomedScene**: Scene with zoom capability
- **VectorScene**: Vector operations
- **LinearTransformationScene**: Linear transformations

---

## 4. Camera Classes

- **Camera**: Base 2D camera
- **MovingCamera**: Panning camera
- **ThreeDCamera**: 3D perspective camera
- **MappingCamera**: Custom coordinate mapping
- **MultiCamera**: Multiple views

---

## 5. Colors

### Grayscale
WHITE, BLACK, GRAY_A/B/C/D/E, LIGHT_GRAY, DARK_GRAY

### Primary
PURE_RED, PURE_GREEN, PURE_BLUE

### Color Variants (A=lightest, E=darkest)
- RED, RED_A, RED_B, RED_C, RED_D, RED_E
- GREEN, GREEN_A through GREEN_E
- BLUE, BLUE_A through BLUE_E
- YELLOW, YELLOW_A through YELLOW_E
- TEAL, TEAL_A through TEAL_E
- GOLD, GOLD_A through GOLD_E
- PURPLE, PURPLE_A through PURPLE_E
- MAROON, MAROON_A through MAROON_E

### Special
PINK, LIGHT_PINK, ORANGE, LIGHT_BROWN, DARK_BROWN, GRAY_BROWN

### ManimColor Utilities
```python
ManimColor.from_rgb(r, g, b)
ManimColor.from_hex("#RRGGBB")
color.to_rgb()
color.to_hex()
color.contrasting()  # Returns BLACK or WHITE
```

---

## 6. Constants

### Directions
```python
ORIGIN = (0, 0, 0)
UP     = (0, 1, 0)
DOWN   = (0, -1, 0)
RIGHT  = (1, 0, 0)
LEFT   = (-1, 0, 0)
IN     = (0, 0, -1)  # Into screen
OUT    = (0, 0, 1)   # Out of screen
```

### Diagonals
```python
UL = UP + LEFT
UR = UP + RIGHT
DL = DOWN + LEFT
DR = DOWN + RIGHT
```

### Axes
```python
X_AXIS = (1, 0, 0)
Y_AXIS = (0, 1, 0)
Z_AXIS = (0, 0, 1)
```

### Math
```python
PI = 3.14159...
TAU = 2 * PI
DEGREES = TAU / 360  # Multiply degrees by this
```

### Defaults
```python
DEFAULT_DOT_RADIUS = 0.08
DEFAULT_FONT_SIZE = 48
DEFAULT_STROKE_WIDTH = 4
SMALL_BUFF = 0.1
MED_SMALL_BUFF = 0.25
MED_LARGE_BUFF = 0.5
LARGE_BUFF = 1.0
```

---

## 7. Rate Functions

### Basic
- `linear`: Constant speed
- `smooth`: Smooth acceleration/deceleration
- `smoothstep`, `smootherstep`: Smoother variants

### Ease Functions
- `ease_in_sine`, `ease_out_sine`, `ease_in_out_sine`
- (And many other ease variants)

### Special
- `there_and_back`: Forward then backward
- `there_and_back_with_pause`: With pause in middle
- `running_start`: Starts with motion
- `not_quite_there`: Reaches 90%
- `wiggle`: Oscillates
- `lingering`: Lingers at end
- `exponential_decay`: Exponential decrease
- `rush_into`, `rush_from`: Rapid start/end

---

## 8. Configuration

```python
from manim import config, tempconfig

# Rendering
config.renderer = "cairo"  # or "opengl"
config.frame_height = 8
config.frame_width = 14.22
config.pixel_height = 1080
config.pixel_width = 1920
config.frame_rate = 60

# Output
config.media_dir = "./media"
config.write_to_movie = True
config.save_last_frame = False
config.save_as_gif = False

# Background
config.background_color = BLACK
config.background_opacity = 1.0

# Quality presets
config.quality = "low_quality"      # 854x480 @ 15fps
config.quality = "medium_quality"   # 1280x720 @ 30fps
config.quality = "high_quality"     # 1920x1080 @ 60fps
config.quality = "production_quality"  # 2560x1440 @ 60fps
config.quality = "fourk_quality"    # 3840x2160 @ 60fps

# Temporary config changes
with tempconfig({"frame_height": 10}):
    # Config temporarily changed
    pass
# Config restored
```

---

## 9. Mathematical Functions

### Vector Operations (space_ops)
```python
norm_squared(v)
cross(v1, v2)
normalize(v)
angle_of_vector(vector)
angle_between_vectors(v1, v2)
rotate_vector(vector, angle, axis)
complex_to_R3(complex_num)
R3_to_complex(point)
```

### Geometric Operations
```python
center_of_mass(points)
midpoint(p1, p2)
line_intersection(p1, p2, p3, p4)
get_unit_normal(v1, v2)
compass_directions(n)
regular_vertices(n, radius)
shoelace(x_y)  # Polygon area
```

### Simple Functions
```python
sigmoid(x)
clip(a, min_a, max_a)
choose(n, k)  # Binomial coefficient
binary_search(function, target, lower, upper)
```

---

## 10. Utility Functions

### Iterables
```python
adjacent_pairs(objects)
all_elements_are_instances(iterable, Class)
concatenate_lists(*lists)
listify(obj)
remove_nones(sequence)
resize_array(array, length)
resize_with_interpolation(array, length)
```

---

## 11. Enumerations

### LineJointType
AUTO, ROUND, BEVEL, MITER

### CapStyleType
AUTO, ROUND, BUTT, SQUARE

### RendererType
CAIRO, OPENGL

### Font Styles
NORMAL, ITALIC, OBLIQUE, BOLD, THIN, LIGHT, MEDIUM, SEMIBOLD, HEAVY
