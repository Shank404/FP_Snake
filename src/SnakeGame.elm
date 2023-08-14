module SnakeGame exposing (Msg, main)

import Board exposing (Cell, Direction(..), Grid)
import Browser
import Browser.Events exposing (onKeyDown)
import Color exposing (Color(..))
import Highscore exposing (Highscore, highscoreDecoder)
import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (style)
import Http
import Json.Decode as Decode exposing (Decoder)
import List.NonEmpty exposing (NonEmpty(..))
import Milliseconds exposing (Milliseconds)
import Random
import Snake exposing (Snake)
import Svg exposing (Svg, circle, rect, svg)
import Svg.Attributes exposing (cx, cy, fill, height, r, rx, ry, width, x, y)
import Time



-- Model


type State
    = Stopped CrashReason
    | Running Input Milliseconds
    | Error


type CrashReason
    = Collision
    | OutOfBounds


type Input
    = Direction Direction
    | Unknown


type Data value
    = Loading
    | Failure Http.Error
    | Success value


type alias Model =
    { state : State, snake : Snake, collectable : Maybe Cell, data : Data Highscore }


cellSize : Int
cellSize =
    25


mainContentStyle : List (Attribute msg)
mainContentStyle =
    [ height "100vh"
    , width "100vw"
    , style "display" "grid"
    , style "grid-template-rows" ".2fr 1fr .2fr"
    , style "grid-template-columns" ".3fr 1fr"
    , style "grid-template-areas" "\" . . \" \" status game\" \" . .\""
    , style "justify-items" "center"
    , style "align-items" "center"
    ]


svgStyle : List (Attribute msg)
svgStyle =
    [ width (String.fromInt (cellSize * Board.gameGrid.xAmount + cellSize))
    , height (String.fromInt (cellSize * Board.gameGrid.yAmount + cellSize))
    , style "grid-area" "game"
    ]


statusStyle : List (Attribute msg)
statusStyle =
    [ style "grid-area" "status"
    ]


init : ( Model, Cmd Msg )
init =
    let
        calcX : Int
        calcX =
            Board.gameGrid.xAmount // 2

        calcY : Int
        calcY =
            Board.gameGrid.yAmount // 2

        initialSnake : Snake
        initialSnake =
            Cons { x = calcX, y = calcY } [ { x = calcX + 1, y = calcY } ]
    in
    ( { state = Running (Direction Up) (Milliseconds.start 100 200)
      , snake = initialSnake
      , collectable = Nothing
      , data = Loading
      }
    , case freeCellGenerator Board.gameGrid initialSnake of
        Nothing ->
            Cmd.none

        Just generator ->
            Random.generate Collectable generator
    )



-- Update


type Msg
    = Key Input
    | Collectable Board.Cell
    | Response (Result Http.Error Highscore)


keyDecoder : Decoder Input
keyDecoder =
    let
        toKey string =
            case string of
                "ArrowUp" ->
                    Direction Up

                "ArrowDown" ->
                    Direction Down

                "ArrowLeft" ->
                    Direction Left

                "ArrowRight" ->
                    Direction Right

                _ ->
                    Unknown
    in
    Decode.map toKey (Decode.field "key" Decode.string)


getHighscoreCmd : Cmd Msg
getHighscoreCmd =
    Http.get
        { url = "http://193.175.181.175/highscores"
        , expect = Http.expectJson Response highscoreDecoder
        }



-- postHighscoreCmd : Highscore -> Cmd Msg
-- postHighscoreCmd score =
--    Http.post
--       { url = "http://193.175.181.175/highscores"
--       , body = emptyBody
--       , expect = Http.expectJson Response highscoreDecoder
--       }


fromResult : Result Http.Error a -> Data a
fromResult result =
    case result of
        Err e ->
            Failure e

        Ok x ->
            Success x


freeCellGenerator : Grid -> Snake -> Maybe (Random.Generator Cell)
freeCellGenerator grid snake =
    let
        freeCells =
            List.filter (\cell -> not (Snake.isOnCell snake cell)) (Board.allCells grid)
    in
    case freeCells of
        [] ->
            Nothing

        firstElement :: restElements ->
            Just (Random.uniform firstElement restElements)


cellToSvg : Color -> Cell -> Svg msg
cellToSvg color cell =
    circle
        [ cx (String.fromInt ((cell.x * cellSize) + (cellSize // 2)))
        , cy (String.fromInt ((cell.y * cellSize) + (cellSize // 2)))
        , r (String.fromInt (cellSize // 2))
        , width (String.fromInt cellSize)
        , height (String.fromInt cellSize)
        , fill
            (Color.toString
                color
            )
        ]
        []


collectiblesToSvg : Maybe Cell -> List (Svg msg)
collectiblesToSvg collectable =
    case collectable of
        Nothing ->
            []

        Just cell ->
            [ cellToSvg Yellow cell ]


snakeToSvg : Snake -> List (Svg msg)
snakeToSvg snake =
    List.NonEmpty.toList (List.NonEmpty.indexedMap (\index -> cellToSvg (Hsl (10 * index) 100 40)) snake)


gridToSvg : Grid -> Svg msg
gridToSvg grid =
    rect
        [ x (String.fromInt 0)
        , y (String.fromInt 0)
        , rx (String.fromInt 15)
        , ry (String.fromInt 15)
        , width (String.fromInt (cellSize * grid.xAmount + cellSize))
        , height (String.fromInt (cellSize * grid.yAmount + cellSize))
        , fill (Color.toString Lightgrey)
        ]
        []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        freeCells =
            freeCellGenerator Board.gameGrid model.snake
    in
    case model.state of
        Running direction time ->
            if Snake.isOutOfBounds model.snake Board.gameGrid then
                ( { model | state = Stopped OutOfBounds }, Cmd.none )

            else if Snake.hasCollision model.snake then
                ( { model | state = Stopped Collision }, Cmd.none )

            else if
                case freeCells of
                    Nothing ->
                        True

                    Just _ ->
                        False
            then
                ( { model | state = Error }, Cmd.none )

            else if Snake.isOnCollectable model.snake model.collectable then
                ( { model
                    | snake = Snake.extend model.snake
                    , state = Running direction (Milliseconds.dec time)
                    , collectable = Nothing
                  }
                , case freeCells of
                    Nothing ->
                        Cmd.none

                    Just generator ->
                        Random.generate Collectable generator
                )

            else
                ( case msg of
                    Key control ->
                        case control of
                            (Direction newDirection) as moveDirection ->
                                { model
                                    | snake =
                                        Snake.move newDirection model.snake
                                    , state = Running moveDirection time
                                }

                            Unknown ->
                                model

                    Collectable cell ->
                        { model
                            | collectable =
                                Just cell
                        }

                    Response result ->
                        { model | data = fromResult result }
                , Cmd.none
                )

        Stopped _ ->
            ( model, Cmd.none )

        Error ->
            ( model, Cmd.none )


checkState : State -> String
checkState state =
    case state of
        Running _ _ ->
            "The game is running."

        Stopped reason ->
            "The game has stopped: "
                ++ (case reason of
                        Collision ->
                            "Collision"

                        OutOfBounds ->
                            "Out of bounds"
                   )

        Error ->
            "Internal application error: "
                ++ "Error has occurred"



-- View


view : Model -> Html Msg
view model =
    div mainContentStyle
        [ svg svgStyle
            ((gridToSvg Board.gameGrid :: collectiblesToSvg model.collectable) ++ List.reverse (snakeToSvg model.snake))
        , div statusStyle [ text (checkState model.state) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions { state } =
    case state of
        Running direction milliseconds ->
            Sub.batch
                [ Time.every
                    (Milliseconds.floatValue milliseconds)
                    (\_ -> Key direction)
                , Sub.map Key (onKeyDown keyDecoder)
                ]

        Stopped _ ->
            Sub.none

        Error ->
            Sub.none



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , subscriptions = subscriptions
        , view = view
        , update =
            update
        }
