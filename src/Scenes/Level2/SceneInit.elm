module Scenes.Level2.SceneInit exposing
    ( nullLevel2Init
    , Level2Init
    , initCommonData
    )

{-| SceneInit

@docs nullLevel2Init
@docs Level2Init
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Level2.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias Level2Init =
    {}


{-| Null Level2Init data
-}
nullLevel2Init : Level2Init
nullLevel2Init =
    {}


{-| Initialize common data
-}
initCommonData : Env -> Level2Init -> CommonData
initCommonData _ _ =
    nullCommonData
