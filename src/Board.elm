module Board exposing (Cell, Direction(..), Grid, allCells, gameGrid, nextCell)

import List.Extra


type alias Grid =
    { xAmount : Int
    , yAmount : Int
    }


type alias Cell =
    { x : Int
    , y : Int
    }


type Direction
    = Up
    | Down
    | Left
    | Right


gameGrid : Grid
gameGrid =
    { xAmount = 19, yAmount = 19 }


nextCell : Direction -> Cell -> Cell
nextCell direction cell =
    case direction of
        Up ->
            { cell
                | y =
                    cell.y - 1
            }

        Down ->
            { cell
                | y =
                    cell.y + 1
            }

        Left ->
            { cell
                | x =
                    cell.x - 1
            }

        Right ->
            { cell
                | x =
                    cell.x + 1
            }


allCells : Grid -> List Cell
allCells grid =
    List.Extra.lift2 Cell (List.range 0 grid.xAmount) (List.range 0 grid.yAmount)
