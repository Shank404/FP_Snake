module Test.List.NonEmpty exposing (suite)

import Expect
import Fuzz
import List.NonEmpty as NonEmpty exposing (NonEmpty(..))
import Test exposing (Test)


suite : Test
suite =
    Test.concat
        [ Test.fuzz
            nelistFuzzer
            "toList nelist yields list with same elements as nelist"
            (\nelist ->
                case toList nelist of
                    [] ->
                        Expect.fail "toList of a non-empty list should never be empty"

                    b :: bs ->
                        Expect.equal (Cons b bs) nelist
            )
        , Test.fuzz2
            nelistFuzzer
            Fuzz.bool
            "length (toList (snoc nelist b)) = length (toList nelist) + 1"
            (\nelist b ->
                Expect.equal (List.length (NonEmpty.toList nelist) + 1)
                    (List.length (NonEmpty.toList (NonEmpty.snoc nelist b)))
            )
        , Test.fuzz2
            Fuzz.bool
            (Fuzz.list Fuzz.bool)
            "head (Cons b list) = b"
            (\b list ->
                Expect.equal b (NonEmpty.head (Cons b list))
            )
        , Test.fuzz2
            nelistFuzzer
            Fuzz.bool
            "last (snoc nelist b) = b"
            (\nelist b ->
                Expect.equal (NonEmpty.last (NonEmpty.snoc nelist b)) b
            )
        , Test.fuzz
            Fuzz.bool
            "removeLast (Cons b []) = []"
            (\b ->
                Expect.equal [] (NonEmpty.removeLast (Cons b []))
            )
        , Test.fuzz2
            nelistFuzzer
            Fuzz.bool
            "removeLast (snoc nelist b) = toList nelist"
            (\nelist b ->
                Expect.equal (NonEmpty.removeLast (NonEmpty.snoc nelist b)) (toList nelist)
            )
        , Test.fuzz
            nelistFuzzer
            "indexedMap (\n _ -> n) list = List.range 0 (length list - 1)"
            (\nelist ->
                Expect.equal
                    (NonEmpty.toList (NonEmpty.indexedMap (\n _ -> n) nelist))
                    (List.range 0 (List.length (NonEmpty.toList nelist) - 1))
            )
        , Test.fuzz
            (Fuzz.intRange 0 5)
            "any identity [False ...] = False"
            (\n ->
                Expect.equal
                    False
                    (NonEmpty.any identity (Cons False (List.repeat n False)))
            )
        , Test.fuzz2
            (Fuzz.intRange 0 5)
            (Fuzz.intRange 0 5)
            "any identity [False ... True ... False] = True"
            (\n m ->
                let
                    list =
                        List.repeat n False ++ True :: List.repeat m False
                in
                case list of
                    [] ->
                        Expect.fail "Generated list should never be empty"

                    b :: bs ->
                        Expect.equal True (NonEmpty.any identity (Cons b bs))
            )
        ]


nelistFuzzer : Fuzz.Fuzzer (NonEmpty Bool)
nelistFuzzer =
    Fuzz.map2 Cons Fuzz.bool (Fuzz.list Fuzz.bool)


toList : NonEmpty a -> List a
toList (Cons x xs) =
    x :: xs
