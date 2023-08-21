module Scenes.Story.Room.Model exposing
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
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (rect)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderTextWithColor, renderTextWithColorCenterMaxWidth)
import Lib.Resources.Base exposing (getResourcePath)
import List exposing (length, map, member)
import List.Extra exposing (getAt, remove, unique)
import Scenes.Story.Room.Common exposing (Camera, Character, Dir(..), EnvC, Map, Model, SceneState(..), State(..), Textbox)
import Scenes.Story.Room.Config exposing (dialog1, dialog2)
import Scenes.Story.SceneInit exposing (StoryInit)
import String exposing (padLeft)
import Tuple exposing (first, second)
import Vector2 exposing (Index(..), from2, get, set, toList)


{-| initModel
Add components here
-}
initModel : EnvC -> StoryInit -> Model
initModel env _ =
    let
        d =
            env.commonData

        map =
            Map d.mapHeight d.mapWidth "room"

        mc =
            Character 0 200 680 d.mcHeight d.mcWidth Still Right 0 0

        camera =
            Camera 0 0 d.camHeight d.camWidth

        investigator =
            Character 1 550 668 222 96 Still Left 0 0

        captain =
            Character 2 2300 673 210 132 Still Left 0 0

        textbox1 =
            Textbox ( 550, 408 ) 450 0 "textbox"

        textbox2 =
            Textbox ( 2300, 420 ) 450 0 "textbox"
    in
    { alpha = 1, mc = mc, npc = from2 investigator captain, textbox = from2 textbox1 textbox2, map = map, keyList = [], prevKey = 0, camera = camera, sceneState = FadeIn }


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
    if model.mc.x >= 3540 && member 67 model.keyList then
        [ ( LayerParentScene, LayerChangeSceneMsg "Level1" ) ]

    else
        []


update : EnvC -> Model -> ( EnvC, Model )
update env model =
    case model.sceneState of
        FadeIn ->
            ( env, model )
                |> updateBlack
                |> isFinishedFadeIn

        Start ->
            ( env, model )
                |> updateStart
                |> isFinishedStart
                |> updateTextbox
                |> updateCam

        Instruction ->
            ( env, model )
                |> updateInstruction
                |> isFinishedInstruction
                |> updateTextbox
                |> updateCam

        Free ->
            ( env, model )
                |> isEnterInstruction
                |> cleanPrevKey
                |> updateMainCharacter
                |> updateNpc
                |> updateTextbox
                |> updateCam


updateBlack : ( EnvC, Model ) -> ( EnvC, Model )
updateBlack ( env, model ) =
    ( env, { model | alpha = model.alpha - 0.015 } )


isFinishedFadeIn : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeIn ( env, model ) =
    if model.alpha <= 0 then
        ( env, { model | sceneState = Start, alpha = 0 } )

    else
        ( env, model )


updateStart : ( EnvC, Model ) -> ( EnvC, Model )
updateStart ( env, model ) =
    let
        npc =
            model.npc

        investigator =
            get Index0 model.npc

        newNpc =
            set Index0 { investigator | dialogIndex = investigator.dialogIndex + 1 } npc
    in
    if model.prevKey == 67 && member 67 model.keyList == False then
        ( env, { model | npc = newNpc, prevKey = 0 } )

    else
        ( env, model )


updateInstruction : ( EnvC, Model ) -> ( EnvC, Model )
updateInstruction ( env, model ) =
    let
        npc =
            model.npc

        captain =
            get Index1 model.npc

        newNpc =
            set Index1 { captain | dialogIndex = captain.dialogIndex + 1 } npc
    in
    if model.prevKey == 67 && member 67 model.keyList == False then
        -- Press c to continue dialog
        ( env, { model | npc = newNpc, prevKey = 0 } )

    else
        ( env, model )


isFinishedStart : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedStart ( env, model ) =
    let
        investigator =
            get Index0 model.npc
    in
    if investigator.dialogIndex == length dialog1 then
        ( env, { model | sceneState = Free } )

    else
        ( env, model )


isFinishedInstruction : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedInstruction ( env, model ) =
    let
        captain =
            get Index1 model.npc
    in
    if captain.dialogIndex == length dialog2 then
        let
            cap =
                get Index1 model.npc

            newCap =
                { cap | dialogIndex = 0 }
        in
        ( env, { model | sceneState = Free, npc = set Index1 newCap model.npc } )

    else
        ( env, model )


isEnterInstruction : ( EnvC, Model ) -> ( EnvC, Model )
isEnterInstruction ( env, model ) =
    let
        cap =
            get Index1 model.npc

        mc =
            model.mc
    in
    if mc.x > cap.x - 300 && mc.x < cap.x + 300 && model.prevKey == 67 && model.sceneState /= Instruction then
        ( env, { model | sceneState = Instruction, prevKey = 0 } )

    else
        ( env, model )


cleanPrevKey : ( EnvC, Model ) -> ( EnvC, Model )
cleanPrevKey ( env, model ) =
    ( env, { model | prevKey = 0 } )


updateCam : ( EnvC, Model ) -> ( EnvC, Model )
updateCam ( env, model ) =
    let
        d =
            env.commonData

        cam =
            model.camera

        m =
            model.map

        c =
            model.mc

        h =
            model.camera.height

        w =
            model.camera.width

        x =
            if c.x <= w // 2 then
                0

            else if c.x >= m.width - w // 2 then
                m.width - w

            else
                c.x - w // 2

        y =
            if c.y < h // 2 then
                0

            else if c.y > m.height - h // 2 then
                m.height - h

            else
                c.y - h // 2
    in
    ( env, { model | camera = { cam | x = x, y = y, width = d.camWidth, height = d.camHeight } } )


updateMainCharacter : ( EnvC, Model ) -> ( EnvC, Model )
updateMainCharacter ( env, model ) =
    let
        c =
            model.mc

        keys =
            model.keyList

        d =
            env.commonData
    in
    if member 39 keys == True && member 37 keys == True then
        ( env, { model | mc = { c | state = Still, currentSpriteIndex = 0 } } )

    else if member 39 keys == True && c.x < d.mapWidth - d.mcWidth // 2 then
        ( env, { model | mc = { c | state = Walking, dir = Right, x = c.x + d.mcSpeed, currentSpriteIndex = c.currentSpriteIndex + 0.12 } } )

    else if member 37 keys == True && c.x > d.mcWidth // 2 then
        ( env, { model | mc = { c | state = Walking, dir = Left, x = c.x - d.mcSpeed, currentSpriteIndex = c.currentSpriteIndex + 0.12 } } )

    else
        ( env, { model | mc = { c | state = Still, currentSpriteIndex = 0 } } )


updateNpc : ( EnvC, Model ) -> ( EnvC, Model )
updateNpc ( env, model ) =
    let
        mcx =
            model.mc.x

        newNpc =
            Vector2.map
                (\c ->
                    if c.x > mcx then
                        { c | dir = Left }

                    else
                        { c | dir = Right }
                )
                model.npc
    in
    ( env, { model | npc = newNpc } )


updateTextbox : ( EnvC, Model ) -> ( EnvC, Model )
updateTextbox ( env, model ) =
    case model.sceneState of
        Start ->
            let
                tb =
                    get Index0 model.textbox

                newtb =
                    if tb.width <= 598 then
                        set Index0 { tb | width = tb.width + 40 } model.textbox

                    else
                        set Index0 { tb | width = 600 } model.textbox
            in
            ( env, { model | textbox = newtb } )

        Free ->
            let
                tb1 =
                    get Index0 model.textbox

                newtb1 =
                    if tb1.width > 0 then
                        set Index0 { tb1 | width = tb1.width - 40 } model.textbox

                    else
                        set Index0 { tb1 | width = 0 } model.textbox

                tb2 =
                    get Index1 model.textbox

                newtb2 =
                    if tb2.width > 0 then
                        set Index1 { tb2 | width = tb2.width - 40 } newtb1

                    else
                        set Index1 { tb2 | width = 0 } newtb1
            in
            ( env, { model | textbox = newtb2 } )

        Instruction ->
            let
                tb =
                    get Index1 model.textbox

                newtb =
                    if tb.width <= 598 then
                        set Index1 { tb | width = tb.width + 40 } model.textbox

                    else
                        set Index1 { tb | width = 600 } model.textbox
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
        (case c.state of
            Still ->
                "mainCharacter_000"

            Walking ->
                "mainCharacter_" ++ padLeft 3 '0' (toString (1 + modBy 6 (floor c.currentSpriteIndex)))

            Interacting _ ->
                ""
        )


renderNpc : EnvC -> Model -> Renderable
renderNpc env model =
    let
        cam =
            model.camera

        renderedNpc =
            Vector2.map
                (\c ->
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
                        (case c.id of
                            1 ->
                                "investigator"

                            2 ->
                                "captain"

                            _ ->
                                ""
                        )
                )
                model.npc
    in
    group [] (toList renderedNpc)


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
        (toList
            (Vector2.map
                (\tb ->
                    if tb.width == 0 then
                        empty

                    else
                        renderSprite env.globalData
                            []
                            ( first tb.center - tb.width // 2 - model.camera.x, second tb.center - tb.height // 2 - model.camera.y )
                            ( tb.width, tb.height )
                            tb.sprite
                )
                model.textbox
            )
        )


renderDialog : EnvC -> Model -> Renderable
renderDialog env model =
    let
        i =
            get Index0 model.npc

        c =
            get Index1 model.npc

        iDialog =
            i.dialogIndex

        cDialog =
            c.dialogIndex

        rendered =
            case model.sceneState of
                Start ->
                    let
                        tb1X =
                            first (get Index0 model.textbox).center - model.camera.x

                        tb1Y =
                            second (get Index0 model.textbox).center - model.camera.y
                    in
                    [ renderTextWithColor env.globalData 45 "INVESTIGATOR" "disposabledroid_bbregular" Color.white ( tb1X - 265, tb1Y - 155 )
                    , renderTextWithColorCenterMaxWidth env.globalData
                        47
                        (case getAt iDialog dialog1 of
                            Just d ->
                                d

                            Nothing ->
                                ""
                        )
                        "disposabledroid_bbregular"
                        Color.black
                        ( tb1X, tb1Y )
                        550
                    ]

                Instruction ->
                    let
                        tb2X =
                            first (get Index1 model.textbox).center - model.camera.x

                        tb2Y =
                            second (get Index1 model.textbox).center - model.camera.y
                    in
                    [ renderTextWithColor env.globalData 45 "CAPTAIN" "disposabledroid_bbregular" Color.white ( tb2X - 265, tb2Y - 155 )
                    , renderTextWithColorCenterMaxWidth env.globalData
                        47
                        (case getAt cDialog dialog2 of
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
            get Index1 model.npc

        cam =
            model.camera

        rendered =
            case model.sceneState of
                Start ->
                    [ renderTextWithColor env.globalData 55 "PRESS       TO CONTINUE" "disposabledroid_bbregular" Color.white ( 50, 960 )
                    , renderSprite env.globalData [] ( 205, 934 ) ( 96, 96 ) "key_c"
                    ]

                Free ->
                    [ renderTextWithColor env.globalData 55 "            TO MOVE" "disposabledroid_bbregular" Color.white ( 50, 960 )
                    , renderSprite env.globalData [] ( 50, 934 ) ( 96, 96 ) "key_leftarrow"
                    , renderSprite env.globalData [] ( 170, 934 ) ( 96, 96 ) "key_rightarrow"
                    , if model.mc.x >= c.x - 300 && model.mc.x <= c.x + 300 then
                        renderSprite env.globalData [] ( c.x - 55 - cam.x, c.y - 190 - cam.y ) ( 96, 96 ) "key_c"

                      else
                        empty
                    , if model.mc.x >= 3540 then
                        renderSprite env.globalData [] ( 3600 - cam.x, 400 - cam.y ) ( 96, 96 ) "key_c"

                      else
                        empty
                    ]

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
--     Canvas.shapes [ Canvas.Settings.Advanced.alpha model.alpha ] [ Canvas.rect ( 0, 0 ) (toFloat env.commonData.camWidth) (toFloat env.commonData.camHeight) ]


renderBlack : EnvC -> Model -> Renderable
renderBlack env model =
    shapes [ fill (Color.rgba 0 0 0 model.alpha) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
