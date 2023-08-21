module Scenes.Transition1.Room.Export exposing
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
import Scenes.Transition1.LayerBase exposing (CommonData)
import Scenes.Transition1.Room.Common exposing (EnvC, Model)
import Scenes.Transition1.Room.Model exposing (initModel, updateModel, viewModel)
import Scenes.Transition1.SceneInit exposing (Transition1Init)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> Transition1Init -> Layer Data CommonData
initLayer env i =
    { name = "Room"
    , data = initModel env i
    , update = updateModel
    , view = viewModel
    }
