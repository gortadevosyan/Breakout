module Scenes.Home.UI.Model exposing
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
import Color exposing (..)
import Lib.Coordinate.Coordinates exposing (..)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (..)
import Lib.Render.Text exposing (..)
import Scenes.Home.SceneInit exposing (HomeInit)
import Scenes.Home.UI.Common exposing (EnvC, Model, nullModel)


{-| initModel
Add components here
-}
initModel : EnvC -> HomeInit -> Model
initModel _ _ =
    Model ( 800, 540 ) ( 800, 670 )


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        MouseDown button pos ->
            if button == 0 then
                if judgeMouseRect pos ( 800, 540 ) ( 300, 90 ) == True then
                    ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Story" ) ], env )

                else if judgeMouseRect pos ( 800, 670 ) ( 300, 90 ) == True then
                    ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Rules" ) ], env )

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
        [ renderSprite env.globalData [] model.buttonNewGame ( 0, 90 ) "starter_newGameButton"
        , renderSprite env.globalData [] model.buttonHowToPlay ( 0, 90 ) "starter_howToPlayButton"
        ]
