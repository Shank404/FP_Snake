module Color exposing (Color(..), toString)


type Color
    = Lightgrey
    | Yellow
    | Hsl Int Int Int


toString : Color -> String
toString color =
    case color of
        Lightgrey ->
            "Lightgrey"

        Yellow ->
            "Yellow"

        Hsl hue saturation lightness ->
            "hsl(" ++ String.fromInt hue ++ " " ++ String.fromInt saturation ++ "% " ++ String.fromInt lightness ++ "%)"
