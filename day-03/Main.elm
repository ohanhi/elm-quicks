module Main exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


update textThatTheUserHasWritten model =
    textThatTheUserHasWritten


view model =
    div []
        [ input [ value model, onInput (\text -> text) ] []
        , br [] []
        , Html.text (toString (isPalindrome model))
        ]


model =
    "Are we not drawn onward, we few, drawn onward to new era?"


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
