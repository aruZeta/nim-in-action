import dom

type
  CanvasRenderingContext* = ref object
    fillStyle* {.importc.}: cstring
    strokeStyle* {.importc.}: cstring

{.push importcpp.}

proc getContext*(canvasElement: Element,
                 contextType: cstring): CanvasRenderingContext

proc fillRect*(context: CanvasRenderingContext,
               x: int,
               y: int,
               width: int,
               height: int)

proc moveTo*(context: CanvasRenderingContext,
             x: int,
             y: int)

proc lineTo*(context: CanvasRenderingContext,
             x: int,
             y: int)

proc stroke*(context: CanvasRenderingContext)

{.pop.}
