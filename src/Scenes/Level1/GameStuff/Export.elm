module Scenes.Level1.GameStuff.Export exposing
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
import Scenes.Level1.GameStuff.Common exposing (EnvC, Model)
import Scenes.Level1.GameStuff.Model exposing (initModel, updateModel, viewModel)
import Scenes.Level1.LayerBase exposing (CommonData)
import Scenes.Level1.SceneInit exposing (Level1Init)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> Level1Init -> Layer Data CommonData
initLayer env i =
    { name = "GameStuff"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
