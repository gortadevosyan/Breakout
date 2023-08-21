module Scenes.Home.UI.Common exposing (Model, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Home.LayerBase exposing (CommonData)


{-| Model
Add your own data here.
-}
type alias Model =
    { buttonNewGame : ( Int, Int )
    , buttonHowToPlay : ( Int, Int )
    }


{-| nullModel
-}
nullModel : Model
nullModel =
    { buttonNewGame = ( 0, 0 ), buttonHowToPlay = ( 0, 0 ) }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
