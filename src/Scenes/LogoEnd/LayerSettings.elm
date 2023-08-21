module Scenes.LogoEnd.LayerSettings exposing
    ( LayerDataType(..)
    , LayerT
    )

{-| This module is generated by Messenger, don't modify this.

@docs LayerDataType
@docs LayerT

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.LogoEnd.Background.Export as Background
import Scenes.LogoEnd.LayerBase exposing (CommonData)


{-| LayerDataType
-}
type LayerDataType
    = BackgroundData Background.Data
    | NullLayerData


{-| LayerT
-}
type alias LayerT =
    Layer LayerDataType CommonData
