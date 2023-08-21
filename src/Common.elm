module Common exposing
    ( Model
    , updateSceneStartTime
    , resetSceneStartTime
    , initGlobalData
    , audio
    )

{-| This is the doc for this module

@docs Model
@docs updateSceneStartTime
@docs resetSceneStartTime
@docs initGlobalData
@docs audio

-}

import Audio exposing (Audio, AudioData)
import Base exposing (GlobalData, Msg(..))
import Dict
import Lib.Audio.Audio exposing (getAudio)
import Lib.Audio.Base exposing (AudioRepo)
import Lib.LocalStorage.LocalStorage exposing (decodeLSInfo)
import Scenes.SceneSettings exposing (SceneDataTypes, SceneT)


{-| Model

This is the main model data.

`currentData` and `currentGlobalData` is writable, `currentScene` is readonly, `time` is readonly.

Those data is **not** exposed to the scene.

We only use it in the main update.

-}
type alias Model =
    { currentData : SceneDataTypes --- Writable
    , currentScene : SceneT --- Readonly
    , currentGlobalData : GlobalData --- Writable
    , time : Int --- Readonly
    , audiorepo : AudioRepo
    }


{-| updateSceneStartTime

Add one tick to the scene start time

-}
updateSceneStartTime : Model -> Model
updateSceneStartTime m =
    let
        ogd =
            m.currentGlobalData

        ngd =
            { ogd | sceneStartTime = ogd.sceneStartTime + 1 }
    in
    { m | currentGlobalData = ngd }


{-| resetSceneStartTime
Set the scene starttime to 0.
-}
resetSceneStartTime : Model -> Model
resetSceneStartTime m =
    let
        ogd =
            m.currentGlobalData

        ngd =
            { ogd | sceneStartTime = 0 }
    in
    { m | currentGlobalData = ngd }


{-| initGlobalData

Default settings for globaldata

You may add your own global data.

-}
initGlobalData : GlobalData
initGlobalData =
    { browserViewPort = ( 1280, 720 )
    , realHeight = 720
    , realWidth = 1280
    , startLeft = 0
    , startTop = 0
    , sprites = Dict.empty
    , sceneStartTime = 0
    , mousePos = ( 0, 0 )
    , extraHTML = Nothing
    , localStorage = decodeLSInfo ""
    , lastLocalStorage = decodeLSInfo ""
    }


{-| audio

The audio argument needed in the main model.

-}
audio : AudioData -> Model -> Audio
audio ad model =
    Audio.group (getAudio ad model.audiorepo)
        |> Audio.scaleVolume model.currentGlobalData.localStorage.volume
