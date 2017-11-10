module Main exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Json.Encode as JS


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
            , Http.send getPalindromesHandler (Http.post "http://localhost:3000/" (encode newPalindromes) decoder)
            )

        GotPalindromes palindromes ->
            ( { model
                | savedPalindromes = palindromes
                , error = ""
              }
            , Cmd.none
            )

        GotError error ->
            ( { model | error = toString error }, Cmd.none )


encode palindromes =
    Http.jsonBody (JS.list (List.map JS.string palindromes))


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
    , Http.send getPalindromesHandler (Http.get "http://localhost:3000/" decoder)
    )


decoder =
    Json.list Json.string


getPalindromesHandler response =
    case response of
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
