module Scenes.Level2.Background.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color exposing (rgba)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level2.Background.Common exposing (EnvC, Model, nullModel)
import Scenes.Level2.SceneInit exposing (Level2Init)


{-| initModel
Add components here
-}
initModel : EnvC -> Level2Init -> Model
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
        [ renderSprite env.globalData [] ( 0, 0 ) ( 1920, 1080 ) "background"
        , shapes [ fill (Color.rgba 0 0 0 0.5) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
        ]
