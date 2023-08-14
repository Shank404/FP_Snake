module Highscore exposing (Highscore, highscoreDecoder)

import Json.Decode as Decode exposing (Decoder)


type alias Highscore =
    { name : String
    , score : Int
    , timeStamp : Int
    }


highscoreDecoder : Decoder Highscore
highscoreDecoder =
    Decode.map3 Highscore
        (Decode.field "name" Decode.string)
        (Decode.field "score" Decode.int)
        (Decode.field "timestamp" Decode.int)
