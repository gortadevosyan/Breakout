module Scenes.Level2.GameStuff.Model exposing
    ( initModel
    , updateModel
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel
@docs viewModel

-}

import Array
import Base exposing (..)
import Canvas exposing (Renderable, empty, group, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (alpha, imageSmoothing)
import Color
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (circleFloat, rect, rectFloat)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderText, renderTextWithColorCenter)
import Lib.Resources.Base exposing (getResourcePath)
import MainConfig
import Scenes.Level2.GameStuff.Common exposing (EnvC, Model, SceneState(..), nullModel)
import Scenes.Level2.LayerBase exposing (Ball, Brick, BrickState(..), BrickType(..), Circle, CommonData)
import Scenes.Level2.SceneInit exposing (Level2Init)


{-| initModel
Add components here
-}
initModel : EnvC -> Level2Init -> Model
initModel env _ =
    nullModel env


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        Tick _ ->
            if model.sceneState == Beginning then
                ( { model | sceneState = FadeIn }, [ ( LayerParentScene, LayerSoundMsg "Level2Bgm" (getResourcePath "audio/level.ogg") ALoop ) ], env )

            else if model.sceneState == End then
                ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Transition2" ) ], env )

            else if model.sceneState == Win then
                let
                    ( newEnv, newModel ) =
                        ( env, model |> moveBall |> reflect |> movePaddle |> reflectDeadBorder )
                            |> updateBlackOut
                            |> isFinishedFadeOut
                in
                ( newModel, [ ( LayerParentScene, LayerStopSoundMsg "Level2Bgm" ) ], newEnv )

            else
                let
                    ( newEnv, newModel ) =
                        update env model
                in
                ( newModel, [], newEnv )

        KeyDown key ->
            let
                cur =
                    model.keyList
            in
            ( { model | keyListPre = cur, keyList = cur |> Array.set key True }, [], env )

        KeyUp key ->
            let
                cur =
                    model.keyList
            in
            ( { model | keyListPre = cur, keyList = cur |> Array.set key False }, [], env )

        _ ->
            ( model, [], env )


update : EnvC -> Model -> ( EnvC, Model )
update env model =
    case model.sceneState of
        Start ->
            ( env, model |> moveBall |> reflect |> movePaddle |> ifDead |> ifWin |> updKeyUp env )

        FadeIn ->
            ( env, model )
                |> updateBlack
                |> isFinishedFadeIn

        _ ->
            ( env, model |> updKeyUp env )


updateBlackOut : ( EnvC, Model ) -> ( EnvC, Model )
updateBlackOut ( env, model ) =
    ( env, { model | alpha = model.alpha + 0.005 } )


isFinishedFadeOut : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeOut ( env, model ) =
    if model.alpha >= 1 then
        ( env, { model | sceneState = End, alpha = 1 } )

    else
        ( env, model )


updateBlack : ( EnvC, Model ) -> ( EnvC, Model )
updateBlack ( env, model ) =
    ( env, { model | alpha = model.alpha - 0.015 } )


isFinishedFadeIn : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeIn ( env, model ) =
    if model.alpha <= 0 then
        ( env, { model | sceneState = Start, alpha = 0 } )

    else
        ( env, model )


updKeyUp : EnvC -> Model -> Model
updKeyUp env omodel =
    let
        keyUp key =
            (Array.get key omodel.keyListPre == Just True) && (Array.get key omodel.keyList == Just False)

        model =
            { omodel | keyListPre = omodel.keyList }
    in
    if keyUp 82 then
        -- R
        nullModel env

    else if keyUp 27 then
        -- ESC
        { model
            | sceneState =
                if model.sceneState == Pause then
                    Start

                else if model.sceneState == Start then
                    Pause

                else
                    model.sceneState
        }

    else
        model


ifWin : Model -> Model
ifWin model =
    if List.foldl (\{ state } -> (&&) (state == Disappeared)) True model.bricks then
        { model | sceneState = Win }

    else
        model


ifDead : Model -> Model
ifDead model =
    let
        nballs =
            List.filter (\{ y } -> y <= 1080) model.balls
    in
    if List.length nballs == 0 then
        { model | sceneState = Die, balls = nballs }

    else
        { model | balls = nballs }


moveBall : Model -> Model
moveBall model =
    { model
        | balls =
            List.map
                (\{ x, y, vx, vy, r, electricCharge, track, alphaRatio } ->
                    let
                        dTheta =
                            electricCharge * 0.005 / 4 * MainConfig.timeInterval

                        v =
                            sqrt (vx * vx + vy * vy)

                        theta =
                            atan2 vx vy

                        nTheta =
                            theta + dTheta

                        nvx =
                            v * sin nTheta

                        nvy =
                            v * cos nTheta

                        ntrack =
                            List.append track [ ( x, y ) ]

                        mtrack =
                            if List.length ntrack > 30 then
                                List.drop 1 ntrack

                            else
                                ntrack

                        new_alpha =
                            if alphaRatio < 0.001 then
                                min 1 (alphaRatio + 0.00001)

                            else
                                min 1 (alphaRatio + 0.002)
                    in
                    { x = x + vx, y = y + vy, vx = nvx, vy = nvy, r = r, electricCharge = electricCharge * 0.999, track = mtrack, alphaRatio = new_alpha }
                )
                model.balls
    }


movePaddle : Model -> Model
movePaddle model =
    let
        opaddle =
            model.paddle

        npaddle =
            let
                left =
                    (model.keyList |> Array.get 37 |> Maybe.withDefault False)
                        || (model.keyList |> Array.get 65 |> Maybe.withDefault False)

                right =
                    (model.keyList |> Array.get 39 |> Maybe.withDefault False)
                        || (model.keyList |> Array.get 68 |> Maybe.withDefault False)

                v =
                    20 / 16 * MainConfig.timeInterval
            in
            if left then
                { opaddle | x = max (opaddle.x - v) 0 }

            else if right then
                { opaddle | x = min (opaddle.x + v) 1920 }

            else
                opaddle
    in
    { model | paddle = { npaddle | electricCharge = npaddle.electricCharge * 0.999 } }


reflectDeadBorder : Model -> Model
reflectDeadBorder model =
    let
        nballs =
            List.map reflectBallDeadBorder model.balls
    in
    { model | balls = nballs }


reflect : Model -> Model
reflect model =
    let
        ( fballs, fbricks ) =
            reflectBallsBricks ( model.balls, model.bricks )

        nballs =
            reflectBallsBorder fballs

        ( mballs, mpaddle ) =
            reflectBallsPaddle ( nballs, model.paddle )
    in
    { model | balls = mballs, bricks = fbricks, paddle = mpaddle }


reflectBallsBorder : List Ball -> List Ball
reflectBallsBorder balls =
    List.map reflectBallBorder balls


reflectBallBorder : Ball -> Ball
reflectBallBorder ball =
    let
        x =
            ball.x

        y =
            ball.y

        r =
            ball.r
    in
    if x - r <= 0 && ball.vx < 0 || x + r >= 1920 && ball.vx > 0 then
        { ball | vx = -ball.vx }

    else if y - r <= 0 && ball.vy < 0 then
        { ball | vy = -ball.vy }

    else
        ball


reflectBallDeadBorder : Ball -> Ball
reflectBallDeadBorder ball =
    if ball.y + ball.r >= 1080 && ball.vy > 0 then
        { ball | vy = -ball.vy }

    else
        ball


reflectBallsPaddle : ( List Ball, Circle ) -> ( List Ball, Circle )
reflectBallsPaddle ( balls, paddle ) =
    case balls of
        [] ->
            ( [], paddle )

        ball :: rest ->
            let
                ( nball, npaddle ) =
                    reflectBallPaddle ( ball, paddle )

                ( nballs, npaddle2 ) =
                    reflectBallsPaddle ( rest, npaddle )
            in
            ( nball :: nballs, npaddle2 )


reflectBallPaddle : ( Ball, Circle ) -> ( Ball, Circle )
reflectBallPaddle ( b, c ) =
    if (b.x - c.x) ^ 2 + (b.y - c.y) ^ 2 <= (b.r + c.r) ^ 2 then
        let
            ( vx1, vy1 ) =
                ( b.x - c.x, b.y - c.y )

            ( vx2, vy2 ) =
                ( vx1 / sqrt (vx1 ^ 2 + vy1 ^ 2), vy1 / sqrt (vx1 ^ 2 + vy1 ^ 2) )

            ( vx3, vy3 ) =
                ( vx2 * sqrt (b.vx ^ 2 + b.vy ^ 2), vy2 * sqrt (b.vx ^ 2 + b.vy ^ 2) )

            b_ec =
                (b.electricCharge + c.electricCharge) * 1 / 2

            c_ec =
                (b.electricCharge + c.electricCharge) * 1 / 2
        in
        ( { b | vx = vx3, vy = vy3, electricCharge = b_ec }, { c | electricCharge = c_ec } )

    else
        ( b, c )


reflectBallsBricks : ( List Ball, List Brick ) -> ( List Ball, List Brick )
reflectBallsBricks ( balls, bricks ) =
    case balls of
        [] ->
            ( balls, bricks )

        b :: bs ->
            let
                ( nball, nbricks ) =
                    reflectBallBricks ( b, bricks )

                ( nballs, nbricks2 ) =
                    reflectBallsBricks ( bs, nbricks )
            in
            ( nball :: nballs, nbricks2 )


reflectBallBricks : ( Ball, List Brick ) -> ( Ball, List Brick )
reflectBallBricks ( ball, bricks ) =
    case bricks of
        [] ->
            ( ball, bricks )

        r :: rs ->
            let
                ( nball, nbrick ) =
                    reflectBallBrick ( ball, r )

                ( nball2, nbricks ) =
                    reflectBallBricks ( nball, rs )
            in
            ( nball2, nbrick :: nbricks )


reflectBallBrick : ( Ball, Brick ) -> ( Ball, Brick )
reflectBallBrick ( ball, brick ) =
    if brick.state == NormalState then
        let
            commonData =
                Scenes.Level2.LayerBase.nullCommonData

            x =
                ball.x

            y =
                ball.y

            r =
                ball.r

            x1 =
                brick.x

            y1 =
                brick.y

            x2 =
                brick.x + commonData.brickWidth

            y2 =
                brick.y + commonData.brickHeight
        in
        if x >= x1 && x <= x2 then
            if (y - r <= y1 && y + r >= y1) || (y + r >= y2 && y - r <= y2) then
                if brick.bricktype == Danger then
                    ( { ball | vy = -ball.vy, electricCharge = ball.electricCharge + brick.electricCharge, alphaRatio = 0 }, brick |> updateBrickAttacked )

                else
                    ( { ball | vy = -ball.vy, electricCharge = ball.electricCharge + brick.electricCharge }, brick |> updateBrickAttacked )

            else if y + r >= y1 && y - r <= y2 then
                ( ball, brick |> updateBrick )

            else
                ( ball, brick |> updateBrick )

        else if y >= y1 && y <= y2 then
            if (x - r <= x1 && x + r >= x1) || (x + r >= x2 && x - r <= x2) then
                if brick.bricktype == Danger then
                    ( { ball | vx = -ball.vx, electricCharge = ball.electricCharge + brick.electricCharge, alphaRatio = 0 }, brick |> updateBrickAttacked )

                else
                    ( { ball | vx = -ball.vx, electricCharge = ball.electricCharge + brick.electricCharge }, brick |> updateBrickAttacked )

            else if x + r >= x1 && x - r <= x2 then
                ( ball, brick |> updateBrick )

            else
                ( ball, brick |> updateBrick )

        else if dist x y x1 y1 <= r || dist x y x1 y2 <= r || dist x y x2 y1 <= r || dist x y x2 y2 <= r then
            if brick.bricktype == Danger then
                ( { ball | vx = -ball.vx, vy = -ball.vy, electricCharge = ball.electricCharge + brick.electricCharge, alphaRatio = 0 }, brick |> updateBrickAttacked )

            else
                ( { ball | vx = -ball.vx, vy = -ball.vy, electricCharge = ball.electricCharge + brick.electricCharge }, brick |> updateBrickAttacked )

        else
            ( ball, brick |> updateBrick )

    else
        ( ball, brick |> updateBrick )


updateBrick : Brick -> Brick
updateBrick brick =
    if brick.state == Attacked then
        if brick.animIndex < 4 then
            { brick | animIndex = brick.animIndex + 1 }

        else
            { brick | animIndex = 0, state = Disappeared }

    else
        brick


updateBrickAttacked : Brick -> Brick
updateBrickAttacked brick =
    if brick.state /= Disappeared then
        if brick.state == NormalState then
            { brick | state = Attacked }

        else if brick.animIndex < 4 then
            { brick | animIndex = brick.animIndex + 1 }

        else
            { brick | animIndex = 0, state = Disappeared }

    else
        brick


dist : Float -> Float -> Float -> Float -> Float
dist x1 y1 x2 y2 =
    sqrt ((x1 - x2) ^ 2 + (y1 - y2) ^ 2)


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    case model.sceneState of
        Die ->
            group [ imageSmoothing False ] [ renderGameStuff env model, renderDie env model ]

        Start ->
            group [ imageSmoothing False ] [ renderGameStuff env model ]

        Pause ->
            group [ imageSmoothing False ] [ renderGameStuff env model, renderPause env model ]

        FadeIn ->
            group [ imageSmoothing False ] [ renderGameStuff env model, renderBlack env model ]

        _ ->
            group [ imageSmoothing False ] [ renderGameStuff env model, renderWin env model, renderBlack env model ]


renderGameStuff : EnvC -> Model -> Renderable
renderGameStuff env model =
    group []
        -- shapes [ fill Color.white ]
        -- [ circleFloat env.globalData ( model.paddle.x, model.paddle.y ) model.paddle.r ]
        [ renderPaddle env model, renderBalls env model, renderBricks env model ]


renderPaddle : EnvC -> Model -> Renderable
renderPaddle env model =
    let
        x =
            model.paddle.x

        y =
            model.paddle.y

        r =
            model.paddle.r
    in
    renderSprite env.globalData
        []
        ( (x - r) |> round, (y - r) |> round )
        ( (2 * r) |> round, (2 * r) |> round )
        "paddle"


tweens : List ( Float, Float ) -> List ( Float, Float )
tweens l =
    case l of
        [] ->
            []

        [ z ] ->
            [ z ]

        ( x1, y1 ) :: ( x2, y2 ) :: xs ->
            [ ( x1, y1 ), ( (x1 * 2 + x2) / 3, (y1 * 2 + y2) / 3 ), ( (x1 + x2 * 2) / 3, (y1 + y2 * 2) / 3 ) ] ++ tweens (( x2, y2 ) :: xs)


renderBalls : EnvC -> Model -> Renderable
renderBalls env model =
    group []
        (List.concatMap
            (\{ x, y, r, track, alphaRatio } ->
                List.indexedMap
                    (\i ( tx, ty ) ->
                        shapes
                            [ fill
                                (Color.rgba (0.73725 * 0.97 ^ ((90 - i) |> toFloat))
                                    (0.14901 * 0.97 ^ ((90 - i) |> toFloat))
                                    (0.2549 * 0.97 ^ ((90 - i) |> toFloat))
                                    (max 0.05 alphaRatio * (i |> toFloat) / 150)
                                )
                            ]
                            [ circleFloat env.globalData ( tx, ty ) (r * 0.96 ^ ((90 - i) |> toFloat)) ]
                    )
                    (track |> tweens)
                    ++ [ renderSprite env.globalData
                            [ alpha alphaRatio ]
                            ( (x - r) |> round, (y - r) |> round )
                            ( (2 * r) |> round, (2 * r) |> round )
                            "ball"
                       ]
             -- shapes [ fill Color.yellow ]
             --     [ circleFloat env.globalData ( x, y ) r ]
            )
            model.balls
        )


renderBricks : EnvC -> Model -> Renderable
renderBricks env model =
    let
        commonData =
            env.commonData
    in
    group []
        (List.map
            (\{ x, y, state, electricCharge, bricktype } ->
                case state of
                    NormalState ->
                        renderSprite env.globalData
                            []
                            ( x |> round, y |> round )
                            ( commonData.brickWidth |> round, commonData.brickHeight |> round )
                            (if bricktype == NormalType then
                                "brick_neutral"

                             else if bricktype == Bonus then
                                "brick_bonus"

                             else
                                "brick_danger"
                            )

                    Attacked ->
                        renderSprite env.globalData
                            []
                            ( x |> round, y |> round )
                            ( commonData.brickWidth |> round, commonData.brickHeight |> round )
                            "brick_attacked"

                    Disappeared ->
                        empty
             -- shapes [ fill Color.yellow ]
             --     [ rectFloat env.globalData ( x, y ) ( commonData.brickWidth, commonData.brickHeight ) ]
            )
            model.bricks
        )


renderPause : EnvC -> Model -> Renderable
renderPause env model =
    group []
        [ shapes [ fill (Color.rgba 0 0 0 0.75) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
        , renderTextWithColorCenter env.globalData 160 "PAUSED" "disposabledroid_bbregular" (Color.rgb255 255 255 255) ( 960, 540 )
        ]


renderDie : EnvC -> Model -> Renderable
renderDie env model =
    group []
        [ shapes [ fill (Color.rgba 0 0 0 0.75) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
        , renderTextWithColorCenter env.globalData 160 "YOU FAILED" "disposabledroid_bbregular" (Color.rgb255 250 107 107) ( 960, 500 )
        , renderTextWithColorCenter env.globalData 80 "PRESS       TO RESTART" "disposabledroid_bbregular" (Color.rgb255 250 107 107) ( 960, 650 )
        , renderSprite env.globalData [] ( 833, 600 ) ( 96, 96 ) "key_r"
        ]


renderWin : EnvC -> Model -> Renderable
renderWin env model =
    group []
        [ shapes [ fill (Color.rgba 0 0 0 0.75) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
        , renderTextWithColorCenter env.globalData 160 "YOU WIN !!!" "disposabledroid_bbregular" (Color.rgb255 250 107 107) ( 960, 540 )
        ]


renderBlack : EnvC -> Model -> Renderable
renderBlack env model =
    shapes [ fill (Color.rgba 0 0 0 model.alpha) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
