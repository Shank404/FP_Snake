module Milliseconds exposing (Milliseconds, dec, floatValue, start)


type Milliseconds
    = Milliseconds Int Int


start : Int -> Int -> Milliseconds
start =
    Milliseconds


dec : Milliseconds -> Milliseconds
dec (Milliseconds min max) =
    Milliseconds
        min
        (if max > min then
            max - 5

         else
            min
        )


floatValue : Milliseconds -> Float
floatValue (Milliseconds _ max) =
    toFloat max
