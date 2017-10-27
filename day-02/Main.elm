module Main exposing (..)

import Char
import Html exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


update msg model =
    model


view model =
    Html.text (toString (isPalindrome model))


model =
    "Are?"


isPalindrome input =
    let
        characters =
            String.toList (String.toLower input)

        justLetters =
            List.filter Char.isLower characters

        lettersInReverse =
            List.reverse justLetters
    in
    justLetters == lettersInReverse
