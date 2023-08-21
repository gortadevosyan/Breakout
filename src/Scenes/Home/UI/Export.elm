module Scenes.Home.UI.Export exposing
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
import Scenes.Home.LayerBase exposing (CommonData)
import Scenes.Home.SceneInit exposing (HomeInit)
import Scenes.Home.UI.Common exposing (EnvC, Model)
import Scenes.Home.UI.Model exposing (initModel, updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> HomeInit -> Layer Data CommonData
initLayer env i =
    { name = "UI"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
