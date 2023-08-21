module Scenes.LogoEnd.Background.Export exposing
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
import Scenes.LogoEnd.Background.Common exposing (EnvC, Model)
import Scenes.LogoEnd.Background.Model exposing (initModel, updateModel, viewModel)
import Scenes.LogoEnd.LayerBase exposing (CommonData)
import Scenes.LogoEnd.SceneInit exposing (LogoEndInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> LogoEndInit -> Layer Data CommonData
initLayer env i =
    { name = "Background"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
