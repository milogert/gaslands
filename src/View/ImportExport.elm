module View.ImportExport exposing (view)

import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)

view : Model -> Html Msg
view model =
    div []
        [ button
            [ class "btn btn-primary"
            , onClick Export
            ]
            [ text "Export" ]
        , textarea [ onInput SetImport ] []
        , button [ class "btn btn-primary", onClick Import ]
            [ text "Import" ]
        ]


