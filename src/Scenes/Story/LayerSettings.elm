module Scenes.Story.LayerSettings exposing
    ( LayerDataType(..)
    , LayerT
    )

{-| This module is generated by Messenger, don't modify this.

@docs LayerDataType
@docs LayerT

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Story.Background.Export as Background
import Scenes.Story.LayerBase exposing (CommonData)
import Scenes.Story.Room.Export as Room


{-| LayerDataType
-}
type LayerDataType
    = BackgroundData Background.Data
    | RoomData Room.Data
    | NullLayerData


{-| LayerT
-}
type alias LayerT =
    Layer LayerDataType CommonData
