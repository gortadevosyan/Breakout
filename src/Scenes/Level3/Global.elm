module Scenes.Level3.Global exposing (sceneToST)

{-| Global module

Automatically generated by Messenger.

Don't modify this file.

@docs sceneToST

-}

import Canvas exposing (Renderable)
import Lib.Env.Env exposing (Env)
import Lib.Scene.Base exposing (Scene, SceneInitData, SceneOutputMsg)
import Scenes.Level3.Common exposing (nullModel)
import Scenes.Level3.Export exposing (Data)
import Scenes.SceneSettings exposing (SceneDataTypes(..), SceneT)


dataToSDT : Data -> SceneDataTypes
dataToSDT d =
    Level3DataT d


sdtToData : SceneDataTypes -> Data
sdtToData dt =
    case dt of
        Level3DataT x ->
            x

        _ ->
            nullModel


{-| sceneToST
-}
sceneToST : Scene Data -> SceneT
sceneToST sd =
    let
        init : Env -> SceneInitData -> SceneDataTypes
        init t tm =
            dataToSDT (sd.init t tm)

        update : Env -> SceneDataTypes -> ( SceneDataTypes, List SceneOutputMsg, Env )
        update env sdt =
            let
                ( newm, som, newgd ) =
                    sd.update env (sdtToData sdt)
            in
            ( dataToSDT newm, som, newgd )

        view : Env -> SceneDataTypes -> Renderable
        view env sdt =
            sd.view env (sdtToData sdt)
    in
    { init = init
    , update = update
    , view = view
    }
