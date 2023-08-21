module Scenes.Level2.LayerBase exposing
    ( CommonData, nullCommonData
    , Ball, Brick, BrickState(..), BrickType(..), Circle
    )

{-| LayerBase module

@docs CommonData, nullCommonData

-}

import Angle exposing (normalize)


{-| CommonData
Edit your own CommonData here.
-}
type alias CommonData =
    { brickColNum : Int
    , brickRowNum : Int
    , blockWidth : Float
    , brickWidth : Float
    , blockHeight : Float
    , brickHeight : Float
    , paddleRadius : Float
    }


type alias Circle =
    { x : Float
    , y : Float
    , r : Float
    , electricCharge : Float
    }


type alias Ball =
    { x : Float
    , y : Float
    , r : Float
    , vx : Float
    , vy : Float
    , electricCharge : Float
    , track : List ( Float, Float )
    , alphaRatio : Float
    }


type BrickState
    = NormalState
    | Attacked
    | Disappeared


type BrickType
    = NormalType
    | Danger
    | Bonus


type alias Brick =
    { x : Float
    , y : Float
    , state : BrickState
    , animIndex : Int
    , electricCharge : Float
    , bricktype : BrickType
    }


{-| Init CommonData
-}
nullCommonData : CommonData
nullCommonData =
    let
        brickColNum =
            6

        brickRowNum =
            4

        blockWidth =
            1920 / brickColNum

        blockHeight =
            140

        brickWidth =
            196

        brickHeight =
            98

        paddleRadius =
            130
    in
    { brickColNum =
        brickColNum
    , brickRowNum =
        brickRowNum
    , blockWidth =
        blockWidth
    , brickWidth =
        brickWidth
    , blockHeight =
        blockHeight
    , brickHeight =
        brickHeight
    , paddleRadius =
        paddleRadius
    }
