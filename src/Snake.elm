module Snake exposing (Snake, extend, hasCollision, isOnCell, isOnCollectable, isOutOfBounds, move)

import Board exposing (Cell, Direction, Grid)
import List.NonEmpty exposing (NonEmpty(..))


type alias Snake =
    NonEmpty Cell


move : Direction -> Snake -> Snake
move direction ((Cons head _) as snake) =
    Cons
        (Board.nextCell direction head)
        (List.NonEmpty.removeLast snake)


extend : Snake -> Snake
extend snake =
    List.NonEmpty.snoc snake (List.NonEmpty.last snake)


isOutOfBounds : Snake -> Grid -> Bool
isOutOfBounds (Cons element _) grid =
    element.x < 0 || element.y < 0 || element.x > grid.xAmount || element.y > grid.yAmount


hasCollision : Snake -> Bool
hasCollision (Cons head list) =
    List.any ((==) head) list


isOnCell : Snake -> Cell -> Bool
isOnCell snake cell =
    List.NonEmpty.any ((==) cell) snake


isOnCollectable : Snake -> Maybe Cell -> Bool
isOnCollectable snake food =
    case food of
        Nothing ->
            False

        Just cell ->
            isOnCell snake cell
