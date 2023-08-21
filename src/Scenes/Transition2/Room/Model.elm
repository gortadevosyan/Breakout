module Scenes.Transition2.Room.Model exposing
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
import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (Transform(..), imageSmoothing, transform)
import Color exposing (Color)
import Debug exposing (toString)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderTextWithColor, renderTextWithColorCenterMaxWidth)
import List exposing (length, map, member)
import List.Extra exposing (getAt, remove, unique)
import Scenes.Transition2.Room.Common exposing (Camera, Character, Dir(..), EnvC, Map, Model, SceneState(..), Textbox)
import Scenes.Transition2.SceneInit exposing (Transition2Init)
import String exposing (padLeft)
import Tuple exposing (first, second)
import Vector2 exposing (Index(..), from2, get, set, toList)


dialog : List String
dialog =
    [ "a"
    , "b"
    , "c"
    ]


{-| initModel
Add components here
-}
initModel : EnvC -> Transition2Init -> Model
initModel _ _ =
    let
        map =
            Map 1080 (1920 * 2) "room"

        mc =
            Character 3480 680 198 96 Left 0

        camera =
            Camera 1920 0 1080 1920

        captain =
            Character 3000 673 210 132 Right 0

        textbox =
            Textbox ( 3000, 420 ) 450 0 "textbox"
    in
    { alpha = 1, mc = mc, captain = captain, textbox = textbox, map = map, keyList = [], prevKey = 0, camera = camera, sceneState = FadeIn }


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        KeyDown key ->
            let
                newKeyList =
                    unique (key :: model.keyList)
            in
            ( { model | keyList = newKeyList }, [], env )

        KeyUp key ->
            let
                newKeyList =
                    remove key model.keyList
            in
            ( { model | keyList = newKeyList, prevKey = key }, [], env )

        Tick _ ->
            let
                ( newEnv, newModel ) =
                    update env model
            in
            ( newModel, nextLevel newModel newEnv, newEnv )

        _ ->
            ( model, [], env )


nextLevel : Model -> EnvC -> List ( LayerTarget, LayerMsg )
nextLevel model _ =
    if model.sceneState == Free && member 67 model.keyList then
        [ ( LayerParentScene, LayerChangeSceneMsg "Level3" ) ]

    else
        []


update : EnvC -> Model -> ( EnvC, Model )
update env model =
    case model.sceneState of
        FadeIn ->
            ( env, model )
                |> updateBlack
                |> isFinishedFadeIn

        Instruction ->
            ( env, model )
                |> updateInstruction
                |> isFinishedInstruction
                |> updateTextbox

        Free ->
            ( env, model )
                |> updateTextbox


updateBlack : ( EnvC, Model ) -> ( EnvC, Model )
updateBlack ( env, model ) =
    ( env, { model | alpha = model.alpha - 0.015 } )


isFinishedFadeIn : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeIn ( env, model ) =
    if model.alpha <= 0 then
        ( env, { model | sceneState = Instruction, alpha = 0 } )

    else
        ( env, model )


updateInstruction : ( EnvC, Model ) -> ( EnvC, Model )
updateInstruction ( env, model ) =
    let
        npc =
            model.captain

        newNpc =
            { npc | dialogIndex = npc.dialogIndex + 1 }
    in
    if model.prevKey == 67 && member 67 model.keyList == False then
        -- Press c to continue dialog
        ( env, { model | captain = newNpc, prevKey = 0 } )

    else
        ( env, model )


isFinishedInstruction : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedInstruction ( env, model ) =
    let
        captain =
            model.captain
    in
    if captain.dialogIndex == length dialog then
        let
            newCap =
                { captain | dialogIndex = 0 }
        in
        ( env, { model | sceneState = Free, captain = newCap } )

    else
        ( env, model )


updateTextbox : ( EnvC, Model ) -> ( EnvC, Model )
updateTextbox ( env, model ) =
    case model.sceneState of
        Free ->
            let
                tb =
                    model.textbox

                newtb =
                    if tb.width > 0 then
                        { tb | width = tb.width - 40 }

                    else
                        { tb | width = 0 }
            in
            ( env, { model | textbox = newtb } )

        Instruction ->
            let
                tb =
                    model.textbox

                newtb =
                    if tb.width <= 598 then
                        { tb | width = tb.width + 40 }

                    else
                        { tb | width = 600 }
            in
            ( env, { model | textbox = newtb } )

        _ ->
            ( env, model )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    group [ imageSmoothing False ] [ renderMap env model, renderNpc env model, renderMainCharacter env model, renderTextbox env model, renderDialog env model, renderKeyInstruction env model, renderBlack env model ]


renderMainCharacter : EnvC -> Model -> Renderable
renderMainCharacter env model =
    let
        c =
            model.mc

        cam =
            model.camera
    in
    renderSprite env.globalData
        [ transform
            [ case c.dir of
                Left ->
                    ApplyMatrix { m11 = -1, m12 = 0, m21 = 0, m22 = 1, dx = 48, dy = 0 }

                Right ->
                    Scale 1 1
            ]
        ]
        ( c.x - c.width // 2 - cam.x, c.y - c.height // 2 - cam.y )
        ( c.width, c.height )
        "mainCharacter_000"


renderNpc : EnvC -> Model -> Renderable
renderNpc env model =
    let
        cam =
            model.camera

        renderedNpc =
            model.captain
                |> (\c ->
                        renderSprite env.globalData
                            [ transform
                                [ case c.dir of
                                    Left ->
                                        ApplyMatrix { m11 = -1, m12 = 0, m21 = 0, m22 = 1, dx = 60, dy = 0 }

                                    Right ->
                                        Scale 1 1
                                ]
                            ]
                            ( c.x - c.width // 2 - cam.x, c.y - c.height // 2 - cam.y )
                            ( c.width, c.height )
                            "captain"
                   )
    in
    group [] [ renderedNpc ]


renderMap : EnvC -> Model -> Renderable
renderMap env model =
    let
        x =
            -model.camera.x

        y =
            -model.camera.y

        h =
            model.map.height

        w =
            model.map.width

        s =
            model.map.sprite
    in
    renderSprite env.globalData [] ( x, y ) ( w, h ) s


renderTextbox : EnvC -> Model -> Renderable
renderTextbox env model =
    group []
        [ model.textbox
            |> (\tb ->
                    if tb.width == 0 then
                        empty

                    else
                        renderSprite env.globalData
                            []
                            ( first tb.center - tb.width // 2 - model.camera.x, second tb.center - tb.height // 2 - model.camera.y )
                            ( tb.width, tb.height )
                            tb.sprite
               )
        ]


renderDialog : EnvC -> Model -> Renderable
renderDialog env model =
    let
        c =
            model.captain

        cDialog =
            c.dialogIndex

        rendered =
            case model.sceneState of
                Instruction ->
                    let
                        tb2X =
                            first model.textbox.center - model.camera.x

                        tb2Y =
                            second model.textbox.center - model.camera.y
                    in
                    [ renderTextWithColor env.globalData 45 "CAPTAIN" "disposabledroid_bbregular" Color.white ( tb2X - 265, tb2Y - 155 )
                    , renderTextWithColorCenterMaxWidth env.globalData
                        47
                        (case getAt cDialog dialog of
                            Just d ->
                                d

                            Nothing ->
                                ""
                        )
                        "disposabledroid_bbregular"
                        Color.black
                        ( tb2X, tb2Y )
                        550
                    ]

                _ ->
                    [ empty ]
    in
    group [] rendered


renderKeyInstruction : EnvC -> Model -> Renderable
renderKeyInstruction env model =
    let
        c =
            model.captain

        cam =
            model.camera

        rendered =
            case model.sceneState of
                Free ->
                    [ renderSprite env.globalData [] ( 3600 - cam.x, 400 - cam.y ) ( 96, 96 ) "key_c" ]

                Instruction ->
                    [ renderTextWithColor env.globalData 55 "PRESS       TO CONTINUE" "disposabledroid_bbregular" Color.white ( 50, 960 )
                    , renderSprite env.globalData [] ( 205, 934 ) ( 96, 96 ) "key_c"
                    ]

                _ ->
                    [ empty ]
    in
    group [] rendered



-- renderBlack : EnvC -> Model -> Renderable
-- renderBlack env model =
--     Canvas.shapes [ Canvas.Settings.Advanced.alpha model.alpha ] [ Canvas.rect ( 0, 0 ) 1920 1080 ]


renderBlack : EnvC -> Model -> Renderable
renderBlack env model =
    shapes [ fill (Color.rgba 0 0 0 model.alpha) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
