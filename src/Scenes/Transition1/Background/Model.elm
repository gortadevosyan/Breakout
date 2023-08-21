module Scenes.Transition1.Background.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable, empty, group, toHtml)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Debug exposing (toString)
import Html.Attributes exposing (style)
import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Transition1.Background.Common exposing (EnvC, Model, nullModel)
import Scenes.Transition1.SceneInit exposing (Transition1Init)
import String exposing (padLeft)


{-| initModel
Add components here
-}
initModel : EnvC -> Transition1Init -> Model
initModel _ _ =
    { bgIndex = 0 }


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        Tick _ ->
            let
                ( newModel, newEnv ) =
                    update env model
            in
            ( newModel, [], newEnv )

        _ ->
            ( model, [], env )


update : EnvC -> Model -> ( Model, EnvC )
update env model =
    ( model, env )
        |> updateBg


updateBg : ( Model, EnvC ) -> ( Model, EnvC )
updateBg ( model, env ) =
    ( { model | bgIndex = model.bgIndex + 0.05 }, env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group [ imageSmoothing False ]
        [ renderBg env model
        , renderPlanet env model
        ]


renderPlanet : EnvC -> Model -> Renderable
renderPlanet env model =
    renderSprite env.globalData [] ( 200, 180 ) ( 0, 600 ) ("planet_" ++ padLeft 3 '0' (toString (modBy 25 (floor model.bgIndex))))


renderBg : EnvC -> Model -> Renderable
renderBg env _ =
    renderSprite env.globalData [] ( 0, 0 ) ( 0, 1080 ) "story_bg"
