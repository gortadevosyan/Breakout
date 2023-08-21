module Scenes.Story.Room.Common exposing
    ( Model, nullModel, EnvC
    , Camera, Character, Dir(..), Map, SceneState(..), State(..), Textbox
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas.Texture exposing (sprite)
import Lib.Env.Env as Env
import Scenes.Story.LayerBase exposing (CommonData)
import Vector2 exposing (Vector2, from2)



-- import Html.Attributes exposing (height)
-- import Main exposing (main)


{-| Model
Add your own data here.
-}
type alias Model =
    { mc : Character -- the main character
    , npc : Vector2 Character
    , textbox : Vector2 Textbox
    , map : Map
    , keyList : List Int
    , prevKey : Int
    , camera : Camera
    , sceneState : SceneState
    , alpha : Float
    }


type SceneState
    = Start
    | Free
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
    { id : Int
    , x : Int
    , y : Int
    , height : Int
    , width : Int
    , state : State
    , dir : Dir
    , currentSpriteIndex : Float
    , dialogIndex : Int
    }


type alias Textbox =
    { center : ( Int, Int )
    , height : Int
    , width : Int
    , sprite : String
    }


type State
    = Walking
    | Interacting Int
    | Still


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
            Character 0 0 0 0 0 Still Right 0 0

        camera =
            Camera 0 0 0 0

        tb =
            Textbox ( 0, 0 ) 0 0 ""
    in
    { alpha = 1, mc = mc, npc = from2 mc mc, textbox = from2 tb tb, map = map, keyList = [], prevKey = 0, camera = camera, sceneState = FadeIn }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
