module Scenes.Level2.GameStuff.Export exposing
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
import Scenes.Level2.GameStuff.Common exposing (EnvC, Model)
import Scenes.Level2.GameStuff.Model exposing (initModel, updateModel, viewModel)
import Scenes.Level2.LayerBase exposing (CommonData)
import Scenes.Level2.SceneInit exposing (Level2Init)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> Level2Init -> Layer Data CommonData
initLayer env i =
    { name = "GameStuff"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
