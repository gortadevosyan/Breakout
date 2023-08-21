module Scenes.LogoEnd.Background.Model exposing
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
import Canvas.Settings.Advanced exposing (alpha, imageSmoothing)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.LogoEnd.Background.Common exposing (EnvC, Model, nullModel)
import Scenes.LogoEnd.SceneInit exposing (LogoEndInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LogoEndInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    ( model, [], env ) |> updateBlack


updateBlack : ( Model, List ( LayerTarget, LayerMsg ), EnvC ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateBlack ( model, _, env ) =
    if model.animIndex == 240 && model.alpha >= 1 then
        ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Home" ) ], env )

    else if model.animIndex == 0 && model.alpha > 0.01 then
        ( { model | alpha = model.alpha - 0.01 }, [], env )

    else if model.animIndex >= 240 then
        ( { model | animIndex = 240, alpha = model.alpha + 0.01 }, [], env )

    else if model.alpha <= 0.01 then
        ( { model | alpha = 0, animIndex = model.animIndex + 1 }, [], env )

    else
        ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group [ imageSmoothing False ] [ renderLogoEnd env model, renderBlack env model ]


renderBlack : EnvC -> Model -> Renderable
renderBlack env model =
    shapes [ fill (Color.rgba 0 0 0 model.alpha) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]


renderLogoEnd : EnvC -> Model -> Renderable
renderLogoEnd env model =
    renderSprite env.globalData [ imageSmoothing False ] ( 0, 0 ) ( 1920, 1080 ) "logo"
