module Scenes.Level1.GameStuff.Model exposing
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
import Canvas.Settings.Advanced exposing (imageSmoothing)
import Color
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Shape exposing (circleFloat, rect, rectFloat)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderText, renderTextWithColorCenter)
import Lib.Resources.Base exposing (getResourcePath)
import Lib.Tools.RNG exposing (genRandomInt)
import MainConfig
import Scenes.Level1.GameStuff.Common exposing (EnvC, Fading(..), Model, nullModel)
import Scenes.Level1.LayerBase exposing (Ball, Brick, BrickState(..), Circle, CommonData, Feature, FeatureState(..), FeatureType(..), nullCommonData)
import Scenes.Level1.SceneInit exposing (Level1Init)


{-| initModel
Add components here
-}
initModel : EnvC -> Level1Init -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg and LayerMsg here

-}
updateModel : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env _ model =
    case env.msg of
        Tick _ ->
            if model.fading == Beginning then
                ( { model | fading = FadingIn }, [ ( LayerParentScene, LayerSoundMsg "Level1Bgm" (getResourcePath "audio/level.ogg") ALoop ) ], env )

            else if model.fading == FadingIn then
                let
                    ( nenv, nmodel ) =
                        ( env, model ) |> updateBlackIn |> isFinishedFadeIn
                in
                ( nmodel, [], nenv )

            else if model.fading == FadingOut then
                let
                    ( nenv, nmodel ) =
                        ( env, model ) |> updateBlackOut |> isFinishedFadeOut
                in
                ( nmodel, [ ( LayerParentScene, LayerStopSoundMsg "Level1Bgm" ) ], nenv )

            else if model.win == True then
                if model.fading == FadingOutEnd then
                    ( model, [ ( LayerParentScene, LayerChangeSceneMsg "Transition1" ) ], env )

                else
                    ( model, [], env )

            else if model.pause then
                ( model |> updKeyUp, [], env )

            else
                let
                    newmodel =
                        model |> moveBall |> reflect |> movePaddle |> ifDead |> ifWin |> updKeyUp

                    newmodel2 =
                        if aliveBricksCount newmodel < aliveBricksCount model then
                            let
                                newFeat =
                                    updateFeature env model.feature
                            in
                            { newmodel | feature = newFeat, paddle = updatePaddle newmodel.paddle env newFeat }

                        else
                            { newmodel | paddle = updatePaddle newmodel.paddle env model.feature }
                in
                ( newmodel2, [], env )

        KeyDown key ->
            let
                cur =
                    model.keyList

                newmodel =
                    model |> updKeyUp

                newmodel2 =
                    if aliveBricksCount newmodel < aliveBricksCount model then
                        let
                            newFeat =
                                updateFeature env model.feature
                        in
                        { newmodel | feature = newFeat, paddle = updatePaddle newmodel.paddle env newFeat }

                    else
                        { newmodel | paddle = updatePaddle newmodel.paddle env model.feature }
            in
            ( { newmodel2 | keyListPre = cur, keyList = cur |> Array.set key True }, [], env )

        KeyUp key ->
            let
                cur =
                    model.keyList
            in
            ( { model | paddle = updatePaddle model.paddle env model.feature, keyListPre = cur, keyList = cur |> Array.set key False }, [], env )

        _ ->
            ( model, [], env )


updateBlackIn : ( EnvC, Model ) -> ( EnvC, Model )
updateBlackIn ( env, model ) =
    ( env, { model | alpha = model.alpha - 0.015 } )


isFinishedFadeIn : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeIn ( env, model ) =
    if model.alpha <= 0 then
        ( env, { model | fading = NoFading, alpha = 0 } )

    else
        ( env, model )


updateBlackOut : ( EnvC, Model ) -> ( EnvC, Model )
updateBlackOut ( env, model ) =
    ( env, { model | alpha = model.alpha + 0.005 } )


isFinishedFadeOut : ( EnvC, Model ) -> ( EnvC, Model )
isFinishedFadeOut ( env, model ) =
    if model.alpha >= 1 then
        ( env, { model | fading = FadingOutEnd, alpha = 1 } )

    else
        ( env, model )


updKeyUp : Model -> Model
updKeyUp omodel =
    let
        keyUp key =
            (Array.get key omodel.keyListPre == Just True) && (Array.get key omodel.keyList == Just False)

        model =
            { omodel | keyListPre = omodel.keyList }
    in
    if keyUp 82 then
        -- R
        nullModel

    else if keyUp 27 then
        -- ESC
        { model | pause = not model.pause }

    else
        model


ifWin : Model -> Model
ifWin model =
    if aliveBricksCount model == 0 then
        { model | alive = False, win = True, fading = FadingOut }

    else
        model


ifDead : Model -> Model
ifDead model =
    let
        nballs =
            List.filter (\{ y } -> y <= 1080) model.balls
    in
    if List.length nballs == 0 then
        { model | alive = False, balls = nballs }

    else
        { model | balls = nballs }


moveBall : Model -> Model
moveBall model =
    { model | balls = List.map (\{ x, y, vx, vy, r } -> { x = x + vx, y = y + vy, vx = vx, vy = vy, r = r }) model.balls }


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
    { model | paddle = npaddle }


reflect : Model -> Model
reflect model =
    let
        ( fballs, fbricks ) =
            reflectBallsBricks ( model.balls, model.bricks )

        nballs =
            reflectBallsBorder fballs

        -- mballs =
        --     reflectBallsPaddle ( nballs, model.paddle )
        mballs =
            reflectBallsPaddle ( nballs, model.paddle )

        sballs =
            removeIntersectBallsPaddle ( mballs, model.paddle )
    in
    { model | balls = sballs, bricks = fbricks }


removeIntersectBallsPaddle : ( List Ball, Circle ) -> List Ball
removeIntersectBallsPaddle ( balls, paddle ) =
    case balls of
        [] ->
            balls

        b :: bs ->
            let
                nball =
                    removeIntersectBallPaddle ( b, paddle )

                nballs =
                    removeIntersectBallsPaddle ( bs, paddle )
            in
            nball :: nballs


removeIntersectBallPaddle : ( Ball, Circle ) -> Ball
removeIntersectBallPaddle ( b, c ) =
    if (b.x - c.x) ^ 2 + (b.y - c.y) ^ 2 <= (b.r + c.r) ^ 2 then
        removeIntersectBallPaddle ( { b | x = b.x + b.vx, y = b.y + b.vy }, c )

    else
        b


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


reflectBallsPaddle : ( List Ball, Circle ) -> List Ball
reflectBallsPaddle ( balls, paddle ) =
    List.map (\ball -> reflectBallPaddle ( ball, paddle )) balls


reflectBallPaddle : ( Ball, Circle ) -> Ball
reflectBallPaddle ( b, c ) =
    if (b.x - c.x) ^ 2 + (b.y - c.y) ^ 2 <= (b.r + c.r) ^ 2 then
        let
            ( vx1, vy1 ) =
                ( b.x - c.x, b.y - c.y )

            ( vx2, vy2 ) =
                ( vx1 / sqrt (vx1 ^ 2 + vy1 ^ 2), vy1 / sqrt (vx1 ^ 2 + vy1 ^ 2) )

            ( vx3, vy3 ) =
                ( vx2 * sqrt (b.vx ^ 2 + b.vy ^ 2), vy2 * sqrt (b.vx ^ 2 + b.vy ^ 2) )
        in
        { b | vx = vx3, vy = vy3 }

    else
        b


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
    if brick.state == Normal then
        let
            commonData =
                Scenes.Level1.LayerBase.nullCommonData

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
                ( { ball | vy = -ball.vy }, brick |> updateBrickAttacked )

            else if y + r >= y1 && y - r <= y2 then
                ( ball, brick |> updateBrick )

            else
                ( ball, brick |> updateBrick )

        else if y >= y1 && y <= y2 then
            if (x - r <= x1 && x + r >= x1) || (x + r >= x2 && x - r <= x2) then
                ( { ball | vx = -ball.vx }, brick |> updateBrickAttacked )

            else if x + r >= x1 && x - r <= x2 then
                ( ball, brick |> updateBrick )

            else
                ( ball, brick |> updateBrick )

        else if dist x y x1 y1 <= r || dist x y x1 y2 <= r || dist x y x2 y1 <= r || dist x y x2 y2 <= r then
            ( { ball | vx = -ball.vx, vy = -ball.vy }, brick |> updateBrickAttacked )

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
        if brick.state == Normal then
            { brick | state = Attacked }

        else if brick.animIndex < 16 then
            { brick | animIndex = brick.animIndex + 1 }

        else
            { brick | animIndex = 0, state = Disappeared }

    else
        brick


dist : Float -> Float -> Float -> Float -> Float
dist x1 y1 x2 y2 =
    sqrt ((x1 - x2) ^ 2 + (y1 - y2) ^ 2)


updateFeature : EnvC -> Feature -> Feature
updateFeature env feat =
    let
        newFeat =
            if env.t - feat.startTime < 1000 then
                feat

            else
                genFeature env
    in
    newFeat


genFeature : EnvC -> Feature
genFeature env =
    let
        newState =
            if genRandomInt env.t ( 0, 100 ) > 10 then
                Active

            else
                Passive

        newType =
            if genRandomInt env.t ( 1, 2 ) > 1 then
                Big

            else
                Small

        startTime =
            env.t
    in
    { state = newState, featType = newType, startTime = startTime }


updatePaddle : Circle -> EnvC -> Feature -> Circle
updatePaddle paddle env feat =
    case feat.state of
        Active ->
            if env.t == feat.startTime then
                case feat.featType of
                    Big ->
                        { paddle | r = paddle.r * 1.5 }

                    Small ->
                        { paddle | r = paddle.r / 1.5 }

            else if env.t - feat.startTime < 1000 then
                paddle

            else
                { paddle | r = nullCommonData.paddleRadius }

        Passive ->
            { paddle | r = nullCommonData.paddleRadius }


aliveBricksCount : Model -> Int
aliveBricksCount model =
    let
        aliveList =
            List.filter (\x -> x.state == Normal) model.bricks
    in
    List.length aliveList


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        commonData =
            Scenes.Level1.LayerBase.nullCommonData
    in
    group []
        ([ if model.win == True then
            renderWin env model
            -- renderTextWithColorCenter env.globalData 80 "You win !!! " "Arial" (Color.rgb255 250 107 107) ( 960, 540 )

           else if model.alive == False then
            renderDie env model
            -- renderTextWithColorCenter env.globalData 80 "You died. Press R to restart. " "Arial" (Color.rgb255 250 107 107) ( 960, 540 )

           else
            let
                gameStuff =
                    -- shapes [ fill Color.white ]
                    -- [ circleFloat env.globalData ( model.paddle.x, model.paddle.y ) model.paddle.r ]
                    (let
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
                    )
                        :: List.map
                            (\{ x, y, r } ->
                                renderSprite env.globalData
                                    []
                                    ( (x - r) |> round, (y - r) |> round )
                                    ( (2 * r) |> round, (2 * r) |> round )
                                    "ball"
                             -- shapes [ fill Color.yellow ]
                             --     [ circleFloat env.globalData ( x, y ) r ]
                            )
                            model.balls
                        ++ List.map
                            (\{ x, y, state } ->
                                case state of
                                    Normal ->
                                        renderSprite env.globalData
                                            []
                                            ( x |> round, y |> round )
                                            ( commonData.brickWidth |> round, commonData.brickHeight |> round )
                                            "brick"

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
            in
            if model.pause == False then
                group [ imageSmoothing False ] gameStuff

            else
                group []
                    (gameStuff
                        ++ [ renderPause env model

                           --      shapes [ fill (Color.rgba 0 0 0 0.5) ] [ rect env.globalData ( 0, 0 ) ( 1920, 1080 ) ]
                           --    , renderTextWithColorCenter env.globalData 80 "Paused" "Arial" (Color.rgb255 250 107 107) ( 960, 540 )
                           ]
                    )
         ]
            ++ [ renderBlack env model ]
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
