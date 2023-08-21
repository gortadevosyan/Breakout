module Lib.Resources.Base exposing
    ( getTexture
    , saveSprite
    , igetSprite
    , allTexture
    , getResourcePath
    )

{-|


# Resource

There are many assets (images) in our game, so it's important to manage them.

In elm-canvas, we have to preload all the images before the game starts.

The game will only start when all resources are loaded.

If some asset is not found, the game will panic and throw an error (alert).

After the resources are loaded, we can get those data from globaldata.sprites.

@docs getTexture
@docs saveSprite
@docs igetSprite
@docs allTexture
@docs getResourcePath

-}

import Base exposing (Msg(..))
import Canvas.Texture as Texture exposing (Texture)
import Dict exposing (Dict, get)


{-| Get the path of the resource.
-}
getResourcePath : String -> String
getResourcePath x =
    "assets/" ++ x


{-| getTexture

Return all the textures.

-}
getTexture : List (Texture.Source Msg)
getTexture =
    List.map (\( x, y ) -> Texture.loadFromImageUrl y (TextureLoaded x)) allTexture


{-| saveSprite
-}
saveSprite : Dict String Texture -> String -> Texture -> Dict String Texture
saveSprite dst name text =
    Dict.insert name text dst


{-| igetSprite

Get the texture by name.

-}
igetSprite : String -> Dict String Texture -> Maybe Texture
igetSprite name dst =
    Dict.get name dst


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
][
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
]

-}
allTexture : List ( String, String )
allTexture =
    [ ( "planet_000", getResourcePath "img/planet/tile000.png" )
    , ( "planet_001", getResourcePath "img/planet/tile001.png" )
    , ( "planet_002", getResourcePath "img/planet/tile002.png" )
    , ( "planet_003", getResourcePath "img/planet/tile003.png" )
    , ( "planet_004", getResourcePath "img/planet/tile004.png" )
    , ( "planet_005", getResourcePath "img/planet/tile005.png" )
    , ( "planet_006", getResourcePath "img/planet/tile006.png" )
    , ( "planet_007", getResourcePath "img/planet/tile007.png" )
    , ( "planet_008", getResourcePath "img/planet/tile008.png" )
    , ( "planet_009", getResourcePath "img/planet/tile009.png" )
    , ( "planet_010", getResourcePath "img/planet/tile010.png" )
    , ( "planet_011", getResourcePath "img/planet/tile011.png" )
    , ( "planet_012", getResourcePath "img/planet/tile012.png" )
    , ( "planet_013", getResourcePath "img/planet/tile013.png" )
    , ( "planet_014", getResourcePath "img/planet/tile014.png" )
    , ( "planet_015", getResourcePath "img/planet/tile015.png" )
    , ( "planet_016", getResourcePath "img/planet/tile016.png" )
    , ( "planet_017", getResourcePath "img/planet/tile017.png" )
    , ( "planet_018", getResourcePath "img/planet/tile018.png" )
    , ( "planet_019", getResourcePath "img/planet/tile019.png" )
    , ( "planet_020", getResourcePath "img/planet/tile020.png" )
    , ( "planet_021", getResourcePath "img/planet/tile021.png" )
    , ( "planet_022", getResourcePath "img/planet/tile022.png" )
    , ( "planet_023", getResourcePath "img/planet/tile023.png" )
    , ( "planet_024", getResourcePath "img/planet/tile024.png" )

    -- , ( "planet_025", getResourcePath "img/tile025.png" )
    -- , ( "planet_026", getResourcePath "img/tile026.png" )
    -- , ( "planet_027", getResourcePath "img/tile027.png" )
    -- , ( "planet_028", getResourcePath "img/tile028.png" )
    -- , ( "planet_029", getResourcePath "img/tile029.png" )
    -- , ( "planet_030", getResourcePath "img/tile030.png" )
    -- , ( "planet_031", getResourcePath "img/tile031.png" )
    -- , ( "planet_032", getResourcePath "img/tile032.png" )
    -- , ( "planet_033", getResourcePath "img/tile033.png" )
    -- , ( "planet_034", getResourcePath "img/tile034.png" )
    -- , ( "planet_035", getResourcePath "img/tile035.png" )
    -- , ( "planet_036", getResourcePath "img/tile036.png" )
    -- , ( "planet_037", getResourcePath "img/tile037.png" )
    -- , ( "planet_038", getResourcePath "img/tile038.png" )
    -- , ( "planet_039", getResourcePath "img/tile039.png" )
    -- , ( "planet_040", getResourcePath "img/tile040.png" )
    -- , ( "planet_041", getResourcePath "img/tile041.png" )
    -- , ( "planet_042", getResourcePath "img/tile042.png" )
    -- , ( "planet_043", getResourcePath "img/tile043.png" )
    -- , ( "planet_044", getResourcePath "img/tile044.png" )
    -- , ( "planet_045", getResourcePath "img/tile045.png" )
    -- , ( "planet_046", getResourcePath "img/tile046.png" )
    -- , ( "planet_047", getResourcePath "img/tile047.png" )
    -- , ( "planet_048", getResourcePath "img/tile048.png" )
    -- , ( "planet_049", getResourcePath "img/tile049.png" )
    , ( "mainCharacter_001", getResourcePath "img/main_character/run001.png" )
    , ( "mainCharacter_002", getResourcePath "img/main_character/run002.png" )
    , ( "mainCharacter_003", getResourcePath "img/main_character/run003.png" )
    , ( "mainCharacter_004", getResourcePath "img/main_character/run004.png" )
    , ( "mainCharacter_005", getResourcePath "img/main_character/run005.png" )
    , ( "mainCharacter_006", getResourcePath "img/main_character/run006.png" )
    , ( "mainCharacter_000", getResourcePath "img/main_character/still.png" )
    , ( "room", getResourcePath "img/room.png" )
    , ( "investigator", getResourcePath "img/investigator/investigator.png" )
    , ( "textbox", getResourcePath "img/textbox.png" )
    , ( "captain", getResourcePath "img/captain/captain.png" )
    , ( "key_c", getResourcePath "img/keys/c.png" )
    , ( "key_leftarrow", getResourcePath "img/keys/leftarrow.png" )
    , ( "key_rightarrow", getResourcePath "img/keys/rightarrow.png" )
    , ( "story_bg", getResourcePath "img/story_bg.png" )
    , ( "starter_background", getResourcePath "img/start_menu_pic.png" )
    , ( "starter_newGameButton", getResourcePath "img/NewGame.png" )
    , ( "starter_howToPlayButton", getResourcePath "img/HowToPlay.png" )
    , ( "back", getResourcePath "img/Back.png" )
    , ( "rules_rules", getResourcePath "img/Rules.png" )
    , ( "logo", getResourcePath "img/logo.png" )
    , ( "background", getResourcePath "img/background.png" )
    , ( "brick", getResourcePath "img/brick.png" )
    , ( "ball", getResourcePath "img/ball.png" )
    , ( "paddle", getResourcePath "img/paddle.png" )
    , ( "brick_attacked", getResourcePath "img/brick_attacked.png" )
    , ( "brick_neutral", getResourcePath "img/brick_neutral.png" )
    , ( "brick_bonus", getResourcePath "img/brick_bonus.png" )
    , ( "brick_danger", getResourcePath "img/brick_danger.png" )
    , ( "brick_positive", getResourcePath "img/brick_positive.png" )
    , ( "brick_negative", getResourcePath "img/brick_negative.png" )
    , ( "key_r", getResourcePath "img/keys/r.png" )
    ]
