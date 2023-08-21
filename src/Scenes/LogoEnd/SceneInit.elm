module Scenes.LogoEnd.SceneInit exposing
    ( nullLogoEndInit
    , LogoEndInit
    , initCommonData
    )

{-| SceneInit

@docs nullLogoEndInit
@docs LogoEndInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.LogoEnd.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias LogoEndInit =
    {}


{-| Null LogoEndInit data
-}
nullLogoEndInit : LogoEndInit
nullLogoEndInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> LogoEndInit -> CommonData
initCommonData _ _ =
    nullCommonData
