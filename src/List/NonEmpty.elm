module List.NonEmpty exposing (NonEmpty(..), any, head, indexedMap, last, removeLast, snoc, toList)


type NonEmpty a
    = Cons a (List a)


toList : NonEmpty a -> List a
toList (Cons element list) =
    element :: list


snoc : NonEmpty a -> a -> NonEmpty a
snoc (Cons element list1) newElement1 =
    let
        snocList : List a -> a -> List a
        snocList list2 newElement2 =
            case list2 of
                [] ->
                    [ newElement2 ]

                firstElement :: restElements ->
                    firstElement :: snocList restElements newElement2
    in
    Cons element (snocList list1 newElement1)


head : NonEmpty a -> a
head (Cons element _) =
    element


last : NonEmpty a -> a
last (Cons element list1) =
    let
        lastCons : a -> List a -> a
        lastCons firstElement list2 =
            case list2 of
                [] ->
                    firstElement

                secondElement :: restElements ->
                    lastCons secondElement restElements
    in
    lastCons element list1


removeLast : NonEmpty a -> List a
removeLast (Cons element list1) =
    let
        removeLastCons : a -> List a -> List a
        removeLastCons firstElement list2 =
            case list2 of
                [] ->
                    []

                secondElement :: restElements ->
                    firstElement :: removeLastCons secondElement restElements
    in
    removeLastCons element list1


indexedMap : (Int -> a -> b) -> NonEmpty a -> NonEmpty b
indexedMap func (Cons element list1) =
    let
        indexedMapHelper : Int -> List a -> List b
        indexedMapHelper index list2 =
            case list2 of
                [] ->
                    []

                firstElement :: restElements ->
                    func index firstElement :: indexedMapHelper (index + 1) restElements
    in
    Cons (func 0 element) (indexedMapHelper 1 list1)


any : (a -> Bool) -> NonEmpty a -> Bool
any func nonEmpty =
    List.any func (toList nonEmpty)
