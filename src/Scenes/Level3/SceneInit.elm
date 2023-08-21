module Scenes.Level3.SceneInit exposing
    ( nullLevel3Init
    , Level3Init
    , initCommonData
    )

{-| SceneInit

@docs nullLevel3Init
@docs Level3Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Level3.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Level3Init =
    {}


{-| Null Level3Init data
-}
nullLevel3Init : Level3Init
nullLevel3Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Level3Init -> CommonData
initCommonData _ _ =
    nullCommonData
