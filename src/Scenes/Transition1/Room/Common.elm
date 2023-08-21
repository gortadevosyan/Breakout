module Scenes.Transition1.Room.Common exposing (..)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Transition1.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { mc : Character -- the main character
    , captain : Character
    , textbox : Textbox
    , map : Map
    , keyList : List Int
    , prevKey : Int
    , camera : Camera
    , sceneState : SceneState
    , alpha : Float
    }


type SceneState
    = Free
    | Instruction
    | FadeIn


type alias Camera =
    { x : Int
    , y : Int
    , height : Int
    , width : Int
    }


type alias Map =
    { height : Int
    , width : Int
    , sprite : String
    }


type alias Character =
    { x : Int
    , y : Int
    , height : Int
    , width : Int
    , dir : Dir
    , dialogIndex : Int
    }


type alias Textbox =
    { center : ( Int, Int )
    , height : Int
    , width : Int
    , sprite : String
    }


type Dir
    = Left
    | Right


{-| nullModel
-}
nullModel : Model
nullModel =
    let
        map =
            Map 0 0 ""

        mc =
            Character 0 0 0 0 Right 0

        camera =
            Camera 0 0 0 0

        tb =
            Textbox ( 0, 0 ) 0 0 ""
    in
    { alpha = 1, mc = mc, captain = mc, textbox = tb, map = map, keyList = [], prevKey = 0, camera = camera, sceneState = FadeIn }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
