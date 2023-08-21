module Lib.Scene.Base exposing
    ( SceneTMsg(..), SceneOutputMsg(..)
    , Scene, SceneInitData(..)
    , LayerPacker
    )

{-|


# Scene

Scene plays an important role in Messenger.

It is like a "page". You can change scenes in the game.

You have to send data to next scene if you don't store the data in globaldata.

@docs SceneTMsg, SceneOutputMsg
@docs Scene, SceneInitData

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)
import Lib.Env.Env exposing (Env)
import Scenes.Home.SceneInit exposing (HomeInit)
import Scenes.Level1.SceneInit exposing (Level1Init)
import Scenes.Level2.SceneInit exposing (Level2Init)
import Scenes.Level3.SceneInit exposing (Level3Init)
import Scenes.Logo.SceneInit exposing (LogoInit)
import Scenes.LogoEnd.SceneInit exposing (LogoEndInit)
import Scenes.Rules.SceneInit exposing (RulesInit)
import Scenes.Story.SceneInit exposing (StoryInit)
import Scenes.Transition1.SceneInit exposing (Transition1Init)
import Scenes.Transition2.SceneInit exposing (Transition2Init)


{-| Scene
-}
type alias Scene a =
    { init : Env -> SceneInitData -> a
    , update : Env -> a -> ( a, List SceneOutputMsg, Env )
    , view : Env -> a -> Renderable
    }


{-| Data to initilize the scene.
-}
type SceneInitData
    = Transition2InitData Transition2Init
    | Transition1InitData Transition1Init
    | Level3InitData Level3Init
    | Level2InitData Level2Init
    | LogoEndInitData LogoEndInit
    | LogoInitData LogoInit
    | Level1InitData Level1Init
    | RulesInitData RulesInit
    | HomeInitData HomeInit
    | StoryInitData StoryInit
    | SceneTransMsg SceneTMsg
    | NullSceneInitData


{-| SceneTMsg
You can pass some messages to the scene to initilize it (along with the SceneInitData).

Add your own messages here if you want to do more things.

Commonly, a game engine may want to add the engine init settings here.

-}
type SceneTMsg
    = SceneStringMsg String
    | SceneIntMsg Int
    | NullSceneMsg


{-| SceneOutputMsg

When you want to change the scene or play the audio, you have to send those messages to the central controller.

Add your own messages here if you want to do more things.

-}
type SceneOutputMsg
    = SOMChangeScene ( SceneInitData, String )
    | SOMPlayAudio String String AudioOption -- audio name, audio url, audio option
    | SOMAlert String
    | SOMStopAudio String
    | SOMSetVolume Float
    | SOMPrompt String String -- name, title


{-| This datatype is used in Scene definition.
A default scene will have those data in it.
-}
type alias LayerPacker a b =
    { commonData : a
    , layers : List b
    }
