module Main exposing (..)

import Char
import Html


main =
    Html.text (toString (isPalindrome palindrome))


palindrome =
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
