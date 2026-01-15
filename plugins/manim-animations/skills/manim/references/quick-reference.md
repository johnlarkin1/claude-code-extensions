# Manim Quick Reference

## Quick Start

```python
from manim import *

class BasicScene(Scene):
    def construct(self):
        circle = Circle(color=BLUE, fill_opacity=0.5)
        text = Text("Hello Manim", font_size=48)

        self.play(Create(circle))
        self.play(Write(text))
        self.wait(1)
        self.play(FadeOut(circle, text))
```

---

## Essential Imports

```python
from manim import *

# Or specific imports
from manim import Scene, Circle, Square, Line
from manim import Create, Transform, FadeIn, FadeOut
from manim import RED, GREEN, BLUE, WHITE
from manim import UP, DOWN, LEFT, RIGHT, ORIGIN
from manim import config, rate_functions
```

---

## Top 20 Animations

| Animation | Purpose |
|-----------|---------|
| `Create(obj)` | Draw object |
| `FadeIn(obj)` | Fade in |
| `FadeOut(obj)` | Fade out |
| `Transform(obj1, obj2)` | Morph obj1 → obj2 |
| `ReplacementTransform(obj1, obj2)` | Transform + remove original |
| `Write(text)` | Write text |
| `Indicate(obj)` | Highlight pulse |
| `Rotate(obj, angle)` | Rotate |
| `GrowFromCenter(obj)` | Grow from center |
| `FadeToColor(obj, color)` | Fade to color |
| `ApplyMethod(obj, method, *args)` | Apply method |
| `ApplyFunction(obj, func)` | Apply function |
| `MoveAlongPath(obj, path)` | Move along curve |
| `ShowPassingFlash(obj)` | Flash across |
| `AnimationGroup(*anims)` | Play together |
| `Succession(*anims)` | Play in sequence |
| `LaggedStart(*anims)` | Staggered start |
| `Circumscribe(obj)` | Draw border |
| `Flash(point)` | Flash at point |
| `Blink(obj)` | Quick blink |

---

## Top 20 Mobjects

| Mobject | Purpose |
|---------|---------|
| `Circle()` | Circle |
| `Square()` | Square |
| `Rectangle(width, height)` | Rectangle |
| `Line(p1, p2)` | Line |
| `Arrow(p1, p2)` | Arrow |
| `Arc(radius, angle)` | Arc |
| `Dot()` | Dot |
| `Text(string)` | Text |
| `MathTex(latex)` | LaTeX math |
| `Tex(latex)` | TeX text |
| `Polygon([p1, p2, ...])` | Polygon |
| `Triangle()` | Triangle |
| `Star()` | Star |
| `Ellipse()` | Ellipse |
| `VGroup(*objs)` | Group objects |
| `Axes()` | 2D axes |
| `NumberPlane()` | Grid plane |
| `ThreeDAxes()` | 3D axes |
| `ParametricFunction(func)` | Parametric curve |
| `FunctionGraph(func, x_range)` | y=f(x) graph |

---

## Color Palette

```python
# Primary
RED, GREEN, BLUE
PURE_RED, PURE_GREEN, PURE_BLUE

# Accent
YELLOW, TEAL, PURPLE, ORANGE, PINK, GOLD, MAROON

# Grayscale
WHITE, BLACK, GRAY, LIGHT_GRAY, DARK_GRAY

# Variants (A=light, E=dark)
RED_A, RED_B, RED_C, RED_D, RED_E
```

---

## Directions

```python
UP, DOWN, RIGHT, LEFT     # Primary
IN, OUT                   # Z-axis (3D)
UL, UR, DL, DR           # Diagonals
ORIGIN                    # (0, 0, 0)
X_AXIS, Y_AXIS, Z_AXIS   # Axis vectors
```

---

## Rate Functions

```python
rate_func=linear                    # Constant
rate_func=smooth                    # Smooth
rate_func=rate_functions.there_and_back
rate_func=rate_functions.wiggle
rate_func=rate_functions.ease_in_sine
rate_func=rate_functions.ease_out_sine
```

---

## Scene Methods

```python
self.add(obj)                      # Add (no animation)
self.play(anim, run_time=2)        # Play animation
self.wait(1)                       # Wait
self.remove(obj)                   # Remove
self.clear()                       # Clear all
```

---

## Mobject Methods

```python
# Positioning
obj.move_to(ORIGIN)
obj.shift(RIGHT * 2)
obj.align_to(other, UP)
obj.next_to(other, RIGHT)

# Sizing
obj.scale(2)
obj.set_width(3)
obj.set_height(2)

# Appearance
obj.set_color(RED)
obj.set_fill(BLUE, opacity=0.5)
obj.set_stroke(width=4, color=RED)

# Rotation
obj.rotate(PI / 4)
obj.rotate_about_point(angle, point)

# Grouping
group = VGroup(obj1, obj2, obj3)
group.arrange(RIGHT, buff=0.5)
```

---

## Value Tracking

```python
tracker = ValueTracker(0)
number = DecimalNumber(tracker.get_value())
number.add_updater(lambda m: m.set_value(tracker.get_value()))

self.add(number)
self.play(tracker.animate.set_value(10), run_time=2)
```

---

## Animation Composition

```python
# Play together
self.play(Create(circle), FadeIn(text), Rotate(square, PI))

# Sequence
self.play(Create(obj1))
self.wait(0.5)
self.play(Transform(obj1, obj2))

# Succession
self.play(Succession(Create(obj1), Transform(obj1, obj2), FadeOut(obj2)))

# Staggered
self.play(LaggedStart(Create(c1), Create(c2), Create(c3), lag_ratio=0.5))
```

---

## 3D Scene

```python
class My3DScene(ThreeDScene):
    def construct(self):
        cube = Cube()
        sphere = Sphere()
        axes = ThreeDAxes()

        self.add(axes, cube)
        self.move_camera(phi=75*DEGREES, theta=45*DEGREES)
        self.begin_ambient_camera_rotation(rate=2*DEGREES)
```

---

## Configuration

```python
from manim import config

config.frame_height = 8
config.pixel_height = 1080
config.pixel_width = 1920
config.frame_rate = 60
config.background_color = BLACK
config.quality = "high_quality"
```

---

## CLI Commands

```bash
manim scenes.py MyScene           # Render
manim -p scenes.py MyScene        # Preview
manim -s scenes.py MyScene        # Save last frame
manim -a scenes.py MyScene        # All scenes

# Quality
manim -ql scenes.py MyScene       # Low (480p)
manim -qm scenes.py MyScene       # Medium (720p)
manim -qh scenes.py MyScene       # High (1080p)
manim -qk scenes.py MyScene       # 4K
```

---

## File Structure

```
project/
├── scenes.py          # Scene classes
└── media/             # Generated output
    ├── videos/
    ├── images/
    └── Tex/
```

---

## Common Patterns

### Function Graph
```python
axes = Axes(x_range=[-3, 3], y_range=[-1, 5])
graph = axes.plot(lambda x: x**2, color=BLUE)
self.play(Create(axes), Create(graph))
```

### Math Equation
```python
eq = MathTex(r"e^{i\pi} + 1 = 0")
self.play(Write(eq))
```

### Moving Camera
```python
class MovingScene(MovingCameraScene):
    def construct(self):
        self.camera.frame.save_state()
        self.play(self.camera.frame.animate.set(width=5))
        self.play(Restore(self.camera.frame))
```

### Updater Animation
```python
dot = Dot()
dot.add_updater(lambda m, dt: m.shift(RIGHT * dt))
self.add(dot)
self.wait(2)
```
