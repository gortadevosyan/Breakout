module Scenes.Logo.SceneInit exposing
    ( nullLogoInit
    , LogoInit
    , initCommonData
    )

{-| SceneInit

@docs nullLogoInit
@docs LogoInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Logo.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias LogoInit =
    {}


{-| Null LogoInit data
-}
nullLogoInit : LogoInit
nullLogoInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> LogoInit -> CommonData
initCommonData _ _ =
    nullCommonData
