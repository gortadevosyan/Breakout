module Scenes.Transition2.SceneInit exposing
    ( nullTransition2Init
    , Transition2Init
    , initCommonData
    )

{-| SceneInit

@docs nullTransition2Init
@docs Transition2Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Transition2.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Transition2Init =
    {}


{-| Null Transition2Init data
-}
nullTransition2Init : Transition2Init
nullTransition2Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Transition2Init -> CommonData
initCommonData _ _ =
    nullCommonData
