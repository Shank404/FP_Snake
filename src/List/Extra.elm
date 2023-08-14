module List.Extra exposing (lift2)


lift2 : (a -> b -> c) -> List a -> List b -> List c
lift2 func list1 list2 =
    List.concatMap (\x -> List.map (func x) list2) list1
