module Scenes.Level1.Export exposing
    ( Data
    , scene
    )

{-| Export Module

This module is generated by Messenger, don't modify this.

@docs Data
@docs scene

-}

import Lib.Scene.Base exposing (Scene)
import Scenes.Level1.Common exposing (Model, initModel)
import Scenes.Level1.Model exposing (updateModel, viewModel)


{-| Data
-}
type alias Data =
    Model


{-| scene
-}
scene : Scene Data
scene =
    { init = initModel
    , update = updateModel
    , view = viewModel
    }
