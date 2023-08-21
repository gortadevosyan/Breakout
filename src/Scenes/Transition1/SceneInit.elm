module Scenes.Transition1.SceneInit exposing
    ( nullTransition1Init
    , Transition1Init
    , initCommonData
    )

{-| SceneInit

@docs nullTransition1Init
@docs Transition1Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Transition1.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Transition1Init =
    {}


{-| Null Transition1Init data
-}
nullTransition1Init : Transition1Init
nullTransition1Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Transition1Init -> CommonData
initCommonData _ _ =
    nullCommonData
