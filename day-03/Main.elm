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


type Msg
    = UpdateCurrentPalindrome String
    | SavePalindrome


update msg model =
    case msg of
        UpdateCurrentPalindrome text ->
            { model | currentPalindome = text }

        SavePalindrome ->
            { model
                | currentPalindome = ""
                , savedPalindromes =
                    model.currentPalindome :: model.savedPalindromes
            }


view model =
    div []
        [ input
            [ value model.currentPalindome
            , onInput UpdateCurrentPalindrome
            ]
            []
        , br [] []
        , Html.text (toString (isPalindrome model.currentPalindome))
        , br [] []
        , button
            [ onClick SavePalindrome ]
            [ text "Save the palindrome" ]
        , savedPalindromesView model.savedPalindromes
        ]


savedPalindromesView palindromes =
    ul []
        (List.map palindromeView palindromes)


palindromeView palindrome =
    li [] [ text palindrome ]


model =
    { currentPalindome = "Are we not drawn onward, we few, drawn onward to new era?"
    , savedPalindromes = []
    }


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
