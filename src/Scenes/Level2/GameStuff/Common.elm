module Scenes.Level2.GameStuff.Common exposing
    ( Model, nullModel, EnvC
    , SceneState(..)
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Array exposing (Array)
import Lib.Env.Env as Env
import Lib.Tools.RNG exposing (..)
import MainConfig
import Random
import Scenes.Level2.LayerBase exposing (Ball, Brick, BrickState(..), BrickType(..), Circle, CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { paddle : Circle
    , balls : List Ball
    , bricks : List Brick
    , keyList : Array Bool
    , keyListPre : Array Bool
    , sceneState : SceneState
    , alpha : Float
    }


type SceneState
    = Start
    | Die
    | Win
    | Pause
    | FadeIn
    | End
    | Beginning


{-| nullModel
-}
nullModel : EnvC -> Model
nullModel env =
    let
        commonData =
            Scenes.Level2.LayerBase.nullCommonData

        globalData =
            env.globalData

        -- seedMousePos = (Tuple.first globalData.mousePos) * 1926 + (Tuple.second globalData.mousePos)
        -- seedMousePos =
        --     19260817
        seed =
            Random.initialSeed env.t
    in
    { paddle = { x = 1920 / 2, y = 1080 + 20, r = commonData.paddleRadius, electricCharge = 0 }
    , balls =
        [ { x = 1920 / 2
          , y = 1080 + 20 - 50 - commonData.paddleRadius
          , r = 48
          , vx = 2 / 16 * MainConfig.timeInterval
          , vy = -13 / 16 * MainConfig.timeInterval
          , electricCharge = 0
          , track = []
          , alphaRatio = 1
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
                        , state = NormalState
                        , animIndex = 0
                        , electricCharge = 0
                        , bricktype = NormalType
                        }
                    )
                    xList
            )
            yList
            |> randomlizeBricksType seed
    , keyList = Array.repeat 256 False
    , keyListPre = Array.repeat 256 False
    , sceneState = Beginning
    , alpha = 1
    }


randomlizeBricksType : Random.Seed -> List Brick -> List Brick
randomlizeBricksType seed bricks =
    case bricks of
        [] ->
            []

        x :: xs ->
            let
                ( ec, nSeed ) =
                    randPM1 seed

                rec =
                    if ec <= 3 then
                        Danger

                    else if ec <= 8 then
                        Bonus

                    else
                        NormalType
            in
            { x | bricktype = rec } :: randomlizeBricksType nSeed xs


randomlizeElectricChargeBricks : Random.Seed -> List Brick -> List Brick
randomlizeElectricChargeBricks seed bricks =
    case bricks of
        [] ->
            []

        x :: xs ->
            let
                ( ec, nSeed ) =
                    randPM1 seed

                rec =
                    if ec <= 4 then
                        --    1
                        0
                        -- turn off thee electricCharge

                    else if ec <= 8 then
                        --    -1
                        0

                    else
                        0
            in
            { x | electricCharge = rec |> toFloat } :: randomlizeElectricChargeBricks nSeed xs


randPM1 : Random.Seed -> ( Int, Random.Seed )
randPM1 seed =
    Random.step (Random.int 1 24) seed


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
