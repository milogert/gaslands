module View.ImportExport exposing (view)

import Html exposing (Html, button, div, text, textarea)
import Html.Attributes exposing (class, rows, style)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)


view : Model -> Html Msg
view model =
    View.Utils.row
        [ View.Utils.colPlus [ "4" ]
            [ "mb-2" ]
            [ button
                [ class "btn btn-primary btn-block"
                , onClick Export
                ]
                [ icon "download", text " Export" ]
            ]
        , View.Utils.colPlus [ "4" ]
            [ "mb-2" ]
            [ button
                [ class "btn btn-primary btn-block"
                , onClick Share
                ]
                [ icon "share", text " Share" ]
            ]
        , View.Utils.colPlus [ "4" ]
            [ "mb-2" ]
            [ button
                [ class "btn btn-primary btn-block"
                , onClick Import
                ]
                [ icon "upload", text " Import" ]
            ]
        , View.Utils.col "12"
            [ textarea
                [ class "form-control mt-2"
                , onInput SetImport
                , rows 15
                , style [ ( "font-family", "monospace" ) ]
                ]
                [ text model.importValue ]
            ]
        ]
