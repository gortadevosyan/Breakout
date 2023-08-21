module Scenes.Rules.Rulespage.Export exposing
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
import Scenes.Rules.LayerBase exposing (CommonData)
import Scenes.Rules.Rulespage.Common exposing (EnvC, Model)
import Scenes.Rules.Rulespage.Model exposing (initModel, updateModel, viewModel)
import Scenes.Rules.SceneInit exposing (RulesInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> RulesInit -> Layer Data CommonData
initLayer env i =
    { name = "Rulespage"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
