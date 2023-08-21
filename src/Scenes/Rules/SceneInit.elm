module Scenes.Rules.SceneInit exposing
    ( nullRulesInit
    , RulesInit
    , initCommonData
    )

{-| SceneInit

@docs nullRulesInit
@docs RulesInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Rules.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias RulesInit =
    {}


{-| Null RulesInit data
-}
nullRulesInit : RulesInit
nullRulesInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> RulesInit -> CommonData
initCommonData _ _ =
    nullCommonData
