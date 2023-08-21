module Scenes.Transition2.Background.Export exposing
    ( Data
    , initLayer
    )

{-| Export module

The export module for layer.

Although this will not be updated, usually you don't need to change this file.

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Transition2.Background.Common exposing (EnvC, Model)
import Scenes.Transition2.Background.Model exposing (initModel, updateModel, viewModel)
import Scenes.Transition2.LayerBase exposing (CommonData)
import Scenes.Transition2.SceneInit exposing (Transition2Init)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> Transition2Init -> Layer Data CommonData
initLayer env i =
    { name = "Background"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
