module Scenes.Rules.Rulespage.Global exposing (getLayerT)

{-| Global module

This module is generated by Messenger, don't modify this.

@docs getLayerT

-}

import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (Layer, LayerMsg, LayerTarget)
import Messenger.GeneralModel exposing (GeneralModel)
import Scenes.Rules.LayerBase exposing (CommonData)
import Scenes.Rules.LayerSettings exposing (LayerDataType(..), LayerT)
import Scenes.Rules.Rulespage.Common exposing (EnvC, nullModel)
import Scenes.Rules.Rulespage.Export exposing (Data)


dataToLDT : Data -> LayerDataType
dataToLDT data =
    RulespageData data


ldtToData : LayerDataType -> Data
ldtToData ldt =
    case ldt of
        RulespageData x ->
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
