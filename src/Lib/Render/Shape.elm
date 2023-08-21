module Lib.Render.Shape exposing
    ( circle, rect
    , circleFloat, rectFloat
    )

{-|


# Shape Rendering

@docs circle, rect

-}

import Base exposing (GlobalData)
import Canvas
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)


{-| Draw circle based on global dataa.
-}
circle : GlobalData -> ( Int, Int ) -> Int -> Canvas.Shape
circle gd pos r =
    Canvas.circle (posToReal gd pos) (lengthToReal gd r)


circleFloat : GlobalData -> ( Float, Float ) -> Float -> Canvas.Shape
circleFloat gd ( posx, posy ) r =
    Canvas.circle (posToReal gd ( posx |> round, posy |> round )) (lengthToReal gd (r |> round))


{-| Draw rectangle based on global dataa.
-}
rect : GlobalData -> ( Int, Int ) -> ( Int, Int ) -> Canvas.Shape
rect gd pos ( w, h ) =
    Canvas.rect (posToReal gd pos) (lengthToReal gd w) (lengthToReal gd h)


rectFloat : GlobalData -> ( Float, Float ) -> ( Float, Float ) -> Canvas.Shape
rectFloat gd ( posx, posy ) ( w, h ) =
    Canvas.rect (posToReal gd ( posx |> round, posy |> round )) (lengthToReal gd (w |> round)) (lengthToReal gd (h |> round))
