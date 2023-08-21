module Scenes.Level3.Common exposing (Model, nullModel, initModel)

{-| Common module

This module is generated by Messenger, don't modify this.

@docs Model, nullModel, initModel

-}

import Lib.Env.Env exposing (Env, addCommonData)
import Lib.Scene.Base exposing (LayerPacker, SceneInitData(..))
import Scenes.Level3.Background.Export as Background
import Scenes.Level3.Background.Global as BackgroundG
import Scenes.Level3.GameStuff.Export as GameStuff
import Scenes.Level3.GameStuff.Global as GameStuffG
import Scenes.Level3.LayerBase exposing (CommonData, nullCommonData)
import Scenes.Level3.LayerSettings exposing (LayerT)
import Scenes.Level3.SceneInit exposing (initCommonData, nullLevel3Init)


{-| Model
-}
type alias Model =
    LayerPacker CommonData LayerT


{-| nullModel
-}
nullModel : Model
nullModel =
    { commonData = nullCommonData
    , layers = []
    }


{-| Initialize the model
-}
initModel : Env -> SceneInitData -> Model
initModel env init =
    let
        layerInitData =
            case init of
                Level3InitData x ->
                    x

                _ ->
                    nullLevel3Init
    in
    { commonData = initCommonData env layerInitData
    , layers =
        [ BackgroundG.getLayerT <| Background.initLayer (addCommonData nullCommonData env) layerInitData
        , GameStuffG.getLayerT <| GameStuff.initLayer (addCommonData nullCommonData env) layerInitData
        ]
    }
