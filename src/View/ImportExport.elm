module View.ImportExport exposing (view)

import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.Model exposing (..)

view : Model -> Html Msg
view v =
    button
        [ class "btn btn-primary"
        , onClick Export
        ]
        [ text "Export" ]

