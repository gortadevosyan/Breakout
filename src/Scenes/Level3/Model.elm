module Scenes.Level3.Model exposing
    ( handleLayerMsg
    , updateModel
    , viewModel
    )

{-| Scene update module

@docs handleLayerMsg
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env, EnvC, addCommonData, noCommonData)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneInitData(..), SceneOutputMsg(..))
import Scenes.Level3.Common exposing (Model)
import Scenes.Level3.LayerBase exposing (CommonData)


{-| handleLayerMsg

Usually you are adding logic here.

-}
handleLayerMsg : EnvC CommonData -> LayerMsg -> Model -> ( Model, List SceneOutputMsg, EnvC CommonData )
handleLayerMsg env lmsg model =
    case lmsg of
        LayerSoundMsg name path opt ->
            ( model, [ SOMPlayAudio name path opt ], env )

        LayerStopSoundMsg name ->
            ( model, [ SOMStopAudio name ], env )

        LayerChangeSceneMsg name ->
            ( model, [ SOMChangeScene ( NullSceneInitData, name ) ], env )

        _ ->
            ( model, [], env )


{-| updateModel

Default update function. Normally you won't change this function.

-}
updateModel : Env -> Model -> ( Model, List SceneOutputMsg, Env )
updateModel env model =
    let
        ( newdata, msgs, newenv ) =
            updateLayer (addCommonData model.commonData env) model.layers

        nmodel =
            { model | commonData = newenv.commonData, layers = newdata }

        ( newmodel, newsow, newgd2 ) =
            List.foldl (\x ( y, _, cgd ) -> handleLayerMsg cgd x y) ( nmodel, [], newenv ) msgs
    in
    ( newmodel, newsow, noCommonData newgd2 )


{-| Default view function
-}
viewModel : Env -> Model -> Renderable
viewModel env model =
    viewLayer (addCommonData model.commonData env) model.layers
