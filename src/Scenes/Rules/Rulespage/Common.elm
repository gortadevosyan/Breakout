module Scenes.Rules.Rulespage.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Rules.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { buttonBack : ( Int, Int )
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { buttonBack = ( 0, 0 ) }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
