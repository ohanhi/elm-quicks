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
            List.filter
                (\currentChar -> List.member currentChar aToZ)
                characters

        check =
            Debug.log "the letters" justLetters
    in
    True


asciiCodeLowercaseA =
    97


asciiCodeLowercaseZ =
    122


aToZ =
    List.map Char.fromCode (List.range asciiCodeLowercaseA asciiCodeLowercaseZ)
