module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


type Msg
    = FruitSelected String
    | FruitDeselected


type alias Model =
    { fruits : List String
    , selectedFruit : String
    }


model : Model
model =
    { fruits = [ "Banana", "Orange", "Kiwi" ]
    , selectedFruit = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        FruitSelected fruit ->
            { model | selectedFruit = fruit }

        FruitDeselected ->
            { model | selectedFruit = "" }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (FruitSelected "Banana") ] [ text "Banana" ]
        , text ("Selected fruit: " ++ model.selectedFruit)
        ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }
