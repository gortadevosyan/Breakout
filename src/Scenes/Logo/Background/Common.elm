module Scenes.Logo.Background.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Logo.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { alpha : Float
    , animIndex : Int
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { alpha = 1
    , animIndex = 0
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
