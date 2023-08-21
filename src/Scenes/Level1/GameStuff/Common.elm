module Scenes.Level1.GameStuff.Common exposing (..)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Array exposing (Array)
import Lib.Env.Env as Env
import MainConfig
import Scenes.Level1.LayerBase exposing (Ball, Brick, BrickState(..), Circle, CommonData, Feature, FeatureState(..), FeatureType(..))


{-| Model
Add your own data here.
-}
type alias Model =
    { paddle : Circle
    , balls : List Ball
    , bricks : List Brick
    , keyList : Array Bool
    , keyListPre : Array Bool
    , alive : Bool
    , win : Bool
    , pause : Bool
    , feature : Feature
    , fading : Fading
    , alpha : Float
    }


type Fading
    = FadingIn
    | FadingOut
    | NoFading
    | FadingOutEnd
    | Beginning


{-| nullModel
-}
nullModel : Model
nullModel =
    let
        commonData =
            Scenes.Level1.LayerBase.nullCommonData
    in
    { paddle = { x = 1920 / 2, y = 1080, r = commonData.paddleRadius }
    , balls =
        [ { x = 1920 / 2
          , y = 1080 - 50 - 160
          , r = 48
          , vx = 2 / 16 * MainConfig.timeInterval
          , vy = -13 / 16 * MainConfig.timeInterval
          }
        ]
    , bricks =
        let
            xList =
                List.range 0 (commonData.brickColNum - 1)

            yList =
                List.range 0 (commonData.brickRowNum - 1)
        in
        List.concatMap
            (\y ->
                List.map
                    (\x ->
                        { x = (x |> toFloat) * commonData.blockWidth + (commonData.blockWidth - commonData.brickWidth) / 2
                        , y = (y |> toFloat) * commonData.blockHeight + (commonData.blockHeight - commonData.brickHeight) / 2
                        , state = Normal
                        , animIndex = 0
                        }
                    )
                    xList
            )
            yList
    , keyList = Array.repeat 256 False
    , keyListPre = Array.repeat 256 False
    , alive = True
    , win = False
    , pause = False
    , feature = { state = Passive, featType = Big, startTime = 0 }
    , fading = Beginning
    , alpha = 1
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
