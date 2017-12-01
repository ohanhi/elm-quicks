module MainWithOurType exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


type MaybeFruit
    = OneFruit String
    | TwoFruits String String
    | NoFruit


type Msg
    = FruitSelected String
    | FruitDeselected


type alias Model =
    { fruits : List String
    , selectedFruit : MaybeFruit
    }


model : Model
model =
    { fruits = [ "Banana", "Orange", "Kiwi" ]
    , selectedFruit = NoFruit
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        FruitSelected fruit ->
            { model | selectedFruit = updateFruits model.selectedFruit fruit }

        FruitDeselected ->
            { model | selectedFruit = NoFruit }


updateFruits : MaybeFruit -> String -> MaybeFruit
updateFruits maybeFruit newFruit =
    case maybeFruit of
        OneFruit oldFruit ->
            TwoFruits oldFruit newFruit

        TwoFruits oldFruit oldFruit2 ->
            TwoFruits oldFruit2 newFruit

        NoFruit ->
            OneFruit newFruit


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (FruitSelected "Banana") ] [ text "Banana" ]
        , button [ onClick (FruitSelected "Orange") ] [ text "Orange" ]
        , button [ onClick (FruitSelected "Kiwi") ] [ text "Kiwi" ]
        , button [ onClick FruitDeselected ] [ text "Deselect" ]
        , br [] []
        , case model.selectedFruit of
            OneFruit fruit ->
                text ("Selected fruit: " ++ fruit)

            TwoFruits fruit1 fruit2 ->
                text ("Selected fruits: " ++ fruit1 ++ " and " ++ fruit2)

            NoFruit ->
                text "No fruit selected"
        ]


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }
