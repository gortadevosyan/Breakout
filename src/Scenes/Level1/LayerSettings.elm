module Scenes.Level1.LayerSettings exposing
    ( LayerDataType(..)
    , LayerT
    )

{-| This module is generated by Messenger, don't modify this.

@docs LayerDataType
@docs LayerT

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Level1.Background.Export as Background
import Scenes.Level1.GameStuff.Export as GameStuff
import Scenes.Level1.LayerBase exposing (CommonData)


{-| LayerDataType
-}
type LayerDataType
    = BackgroundData Background.Data
    | GameStuffData GameStuff.Data
    | NullLayerData


{-| LayerT
-}
type alias LayerT =
    Layer LayerDataType CommonData