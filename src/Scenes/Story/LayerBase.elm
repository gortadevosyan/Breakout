module Scenes.Story.LayerBase exposing (CommonData, nullCommonData)

{-| LayerBase module

@docs CommonData, nullCommonData

-}


{-| CommonData
Edit your own CommonData here.
-}
type alias CommonData =
    { mapHeight : Int
    , mapWidth : Int
    , mcHeight : Int
    , mcWidth : Int
    , camHeight : Int
    , camWidth : Int
    , mcSpeed : Int
    }


{-| Init CommonData
-}
nullCommonData : CommonData
nullCommonData =
    let
        mh =
            1080

        mw =
            1920 * 2

        mch =
            198

        mcw =
            96

        camh =
            1080

        camw =
            1920

        mcs =
            7
    in
    { mapHeight = mh, mapWidth = mw, mcHeight = mch, mcWidth = mcw, camHeight = camh, camWidth = camw, mcSpeed = mcs }
