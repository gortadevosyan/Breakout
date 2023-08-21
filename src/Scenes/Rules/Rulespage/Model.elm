module Scenes.Rules.Rulespage.Model exposing
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
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (..)
import Scenes.Rules.Rulespage.Common exposing (EnvC, Model, nullModel)
import Scenes.Rules.SceneInit exposing (RulesInit)


{-| initModel
Add components here
-}
initModel : EnvC -> RulesInit -> Model
initModel _ _ =
    { buttonBack = ( 100, 50 ) }


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        MouseDown button pos ->
            if button == 0 then
                if judgeMouseRect pos ( 100, 50 ) ( 180, 90 ) == True then
                    ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Home" ) ], env )

                else
                    ( model, [], env )

            else
                ( model, [], env )

        _ ->
            ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group [ imageSmoothing False ]
        [ renderSprite env.globalData [] ( 0, 0 ) ( 0, 1080 ) "rules_rules"
        , renderSprite env.globalData [] model.buttonBack ( 0, 90 ) "back"
        ]
