module Scenes.Story.Background.Export exposing
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
import Scenes.Story.Background.Common exposing (EnvC, Model)
import Scenes.Story.Background.Model exposing (initModel, updateModel, viewModel)
import Scenes.Story.LayerBase exposing (CommonData)
import Scenes.Story.SceneInit exposing (StoryInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> StoryInit -> Layer Data CommonData
initLayer env i =
    { name = "Background"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
