module Scenes.Level1.SceneInit exposing
    ( nullLevel1Init
    , Level1Init
    , initCommonData
    )

{-| SceneInit

@docs nullLevel1Init
@docs Level1Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Level1.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Level1Init =
    {}


{-| Null Level1Init data
-}
nullLevel1Init : Level1Init
nullLevel1Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Level1Init -> CommonData
initCommonData _ _ =
    nullCommonData
