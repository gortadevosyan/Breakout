module Scenes.Home.Background.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color exposing (..)
import Lib.Coordinate.Coordinates exposing (..)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (..)
import Scenes.Home.Background.Common exposing (EnvC, Model, nullModel)
import Scenes.Home.SceneInit exposing (HomeInit)


{-| initModel
Add components here
-}
initModel : EnvC -> HomeInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env _ =
    group [ imageSmoothing False ]
        [ renderSprite env.globalData [] ( 0, 0 ) ( 0, 1080 ) "starter_background"
        ]
