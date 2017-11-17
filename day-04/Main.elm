module Main exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (list, string)
import Json.Encode


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions model =
    Sub.none


type Msg
    = UpdateCurrentPalindrome String
    | SavePalindrome
    | GotPalindromes (List String)
    | GotError Http.Error


update msg model =
    case msg of
        UpdateCurrentPalindrome text ->
            ( { model | currentPalindome = text }, Cmd.none )

        SavePalindrome ->
            let
                newPalindromes =
                    model.currentPalindome :: model.savedPalindromes
            in
            ( { model
                | currentPalindome = ""
                , savedPalindromes = newPalindromes
              }
            , Http.send handler (Http.post "http://localhost:3000/" (encode newPalindromes) decoder)
            )

        GotPalindromes palindromes ->
            ( { model | savedPalindromes = palindromes }, Cmd.none )

        GotError error ->
            ( { model | error = toString error }, Cmd.none )


encode palindromes =
    Http.jsonBody (Json.Encode.list (List.map Json.Encode.string palindromes))


view model =
    div []
        [ input
            [ value model.currentPalindome
            , onInput UpdateCurrentPalindrome
            ]
            []
        , br [] []
        , text (toString (isPalindrome model.currentPalindome))
        , br [] []
        , button
            [ onClick SavePalindrome ]
            [ text "Save the palindrome" ]
        , savedPalindromesView model.savedPalindromes
        , br [] []
        , text model.error
        ]


savedPalindromesView palindromes =
    ul []
        (List.map palindromeView palindromes)


palindromeView palindrome =
    li [] [ text palindrome ]


init =
    ( { currentPalindome = "Are we not drawn onward, we few, drawn onward to new era?"
      , savedPalindromes = []
      , error = ""
      }
    , Http.send handler (Http.get "http://localhost:3000/" decoder)
    )


decoder =
    Json.Decode.list string


handler result =
    case result of
        Ok palindromes ->
            GotPalindromes palindromes

        Err error ->
            GotError error


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
