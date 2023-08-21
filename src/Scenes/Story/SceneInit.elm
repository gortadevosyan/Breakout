module Scenes.Story.SceneInit exposing
    ( nullStoryInit
    , StoryInit
    , initCommonData
    )

{-| SceneInit

@docs nullStoryInit
@docs StoryInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Story.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias StoryInit =
    {}


{-| Null StoryInit data
-}
nullStoryInit : StoryInit
nullStoryInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> StoryInit -> CommonData
initCommonData _ _ =
    nullCommonData
