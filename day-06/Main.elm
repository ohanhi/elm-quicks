module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


type Msg
    = FruitSelected String
    | FruitDeselected


type alias Model =
    { fruits : List String
    , selectedFruit : Maybe String
    }


model : Model
model =
    { fruits = [ "Banana", "Orange", "Kiwi" ]
    , selectedFruit = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        FruitSelected fruit ->
            { model | selectedFruit = Just fruit }

        FruitDeselected ->
            { model | selectedFruit = Nothing }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (FruitSelected "Banana") ] [ text "Banana" ]
        , button [ onClick (FruitSelected "Orange") ] [ text "Orange" ]
        , button [ onClick (FruitSelected "Kiwi") ] [ text "Kiwi" ]
        , button [ onClick FruitDeselected ] [ text "Deselect" ]
        , br [] []
        , case model.selectedFruit of
            Just fruit ->
                text ("Selected fruit: " ++ fruit)

            Nothing ->
                text "No fruit selected"
        ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }
