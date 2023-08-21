module Scenes.Story.Background.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Story.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { bgIndex : Float
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { bgIndex = 0
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
