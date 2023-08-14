module Test.List.Extra exposing (suite)

import Expect
import Fuzz
import List.Extra as List
import Test exposing (Test)


suite : Test
suite =
    Test.concat
        [ Test.fuzz2
            Fuzz.bool
            (Fuzz.list Fuzz.bool)
            "List.map Tuple.second (lift2 Tuple.pair list2 [b] list) = list"
            (\b list ->
                Expect.equal (List.map Tuple.second (List.lift2 Tuple.pair [ b ] list)) list
            )
        , Test.fuzz2
            (Fuzz.list Fuzz.bool)
            Fuzz.bool
            "List.map Tuple.first (lift2 Tuple.pair list [b]) = list"
            (\list b ->
                Expect.equal (List.map Tuple.first (List.lift2 Tuple.pair list [ b ])) list
            )
        , Test.fuzz2
            (Fuzz.list Fuzz.bool)
            (Fuzz.list Fuzz.bool)
            "List.length (lift2 Tuple.pair list1 list2) = List.length list1 * List.length list2"
            (\list1 list2 ->
                Expect.equal (List.length (List.lift2 Tuple.pair list1 list2)) (List.length list1 * List.length list2)
            )
        ]
