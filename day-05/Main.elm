module Main exposing (..)

import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (list, string)
import Json.Encode


type Msg
    = UpdateCurrentPalindrome String
    | SavePalindrome
    | GotPalindromes (List String)
    | GotError Http.Error


type alias Model =
    { currentPalindome : String
    , savedPalindromes : List String
    , error : String
    }


model : Model
model =
    { currentPalindome = ""
    , savedPalindromes = []
    , error = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
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


encode : List String -> Http.Body
encode palindromes =
    palindromes
        |> List.map Json.Encode.string
        |> Json.Encode.list
        |> Http.jsonBody


view : Model -> Html Msg
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


savedPalindromesView : List String -> Html msg
savedPalindromesView palindromes =
    palindromes
        |> List.map palindromeView
        |> ul []


palindromeView : String -> Html msg
palindromeView palindrome =
    li [] [ text palindrome ]


init : ( Model, Cmd Msg )
init =
    ( model
    , Http.send handler (Http.get "http://localhost:3000/" decoder)
    )


decoder : Json.Decode.Decoder (List String)
decoder =
    Json.Decode.list string


handler : Result Http.Error (List String) -> Msg
handler result =
    case result of
        Ok palindromes ->
            GotPalindromes palindromes

        Err error ->
            GotError error


isPalindrome : String -> Bool
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
