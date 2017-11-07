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
        { view = view
        , update = update
        , init = init
        , subscriptions = always Sub.none
        }


type Msg
    = UpdateCurrentPalindrome String
    | SavePalindrome
    | GotPalindromes (List String)
    | GotError Http.Error
    | SaveOk


update msg model =
    case msg of
        UpdateCurrentPalindrome text ->
            { model | currentPalindome = text } ! []

        SavePalindrome ->
            let
                newPalindromes =
                    model.currentPalindome :: model.savedPalindromes
            in
                { model
                    | currentPalindome = ""
                    , savedPalindromes = newPalindromes
                }
                    ! [ Http.post "http://localhost:3000/" (Http.jsonBody <| encode newPalindromes) (Json.list Json.string)
                            |> Http.send
                                (\response ->
                                    case response of
                                        Ok _ ->
                                            SaveOk

                                        Err error ->
                                            GotError error
                                )
                      ]

        GotPalindromes palindromes ->
            { model
                | savedPalindromes = palindromes
            }
                ! []

        GotError err ->
            { model | errorMaybe = Just err } ! []

        SaveOk ->
            { model | errorMaybe = Nothing } ! []


encode list =
    list
        |> List.map JS.string
        |> JS.list


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
        , model.errorMaybe
            |> Maybe.map (\error -> Html.text (toString error))
            |> Maybe.withDefault (Html.div [] [])
        ]


savedPalindromesView palindromes =
    ul []
        (List.map palindromeView palindromes)


palindromeView palindrome =
    li [] [ text palindrome ]


init =
    { currentPalindome = "Are we not drawn onward, we few, drawn onward to new era?"
    , savedPalindromes = []
    , errorMaybe = Nothing
    }
        ! [ Http.get "http://localhost:3000/" (Json.list Json.string)
                |> Http.send
                    (\response ->
                        case response of
                            Ok savedPalindromes ->
                                GotPalindromes savedPalindromes

                            Err error ->
                                GotError error
                    )
          ]


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
