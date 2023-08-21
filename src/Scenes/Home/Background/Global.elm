module Scenes.Home.Background.Global exposing (getLayerT)

{-| Global module

This module is generated by Messenger, don't modify this.

@docs getLayerT

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Layer, LayerMsg, LayerTarget)
import Messenger.GeneralModel exposing (GeneralModel)
import Scenes.Home.Background.Common exposing (EnvC, nullModel)
import Scenes.Home.Background.Export exposing (Data)
import Scenes.Home.LayerBase exposing (CommonData)
import Scenes.Home.LayerSettings exposing (LayerDataType(..), LayerT)


dataToLDT : Data -> LayerDataType
dataToLDT data =
    BackgroundData data


ldtToData : LayerDataType -> Data
ldtToData ldt =
    case ldt of
        BackgroundData x ->
            x

        _ ->
            nullModel


{-| getLayerT
-}
getLayerT : Layer Data CommonData -> LayerT
getLayerT layer =
    let
        update : EnvC -> LayerMsg -> LayerDataType -> ( LayerDataType, List ( LayerTarget, LayerMsg ), EnvC )
        update env lm ldt =
            let
                ( rldt, newmsg, newenv ) =
                    layer.update env lm (ldtToData ldt)
            in
            ( dataToLDT rldt, newmsg, newenv )

        view : EnvC -> LayerDataType -> Renderable
        view env ldt =
            layer.view env (ldtToData ldt)
    in
    GeneralModel layer.name (dataToLDT layer.data) update view