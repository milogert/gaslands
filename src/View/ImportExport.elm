module View.ImportExport exposing (view)

import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)

view : Model -> Html Msg
view model =
    View.Utils.row
        [ View.Utils.col "6"
            [ button
                [ class "btn btn-primary btn-block btn-lg"
                , onClick Export
                ]
                [ icon "download", text " Export" ]
            ]
        , View.Utils.col "6"
            [ button [ class "btn btn-primary btn-block btn-lg", onClick Import ]
                [ icon "upload", text " Import" ]
            , div [] [ textarea [ class "form-control mt-2", onInput SetImport ] [] ]
            ]
        ]


