module View.ImportExport exposing (view)

import Html exposing (Html, button, div, text, textarea, ul, li, a)
import Html.Attributes exposing (class, rows, style, href)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)


view : Model -> Html Msg
view model =
    let
        teamName =
            case model.teamName of
                Nothing ->
                    "NoName"

                Just s ->
                    s
    in
        div []
            [ View.Utils.row
                [ View.Utils.colPlus [ "md-4", "12" ]
                    [ "mb-2" ]
                    [ button
                        [ class "btn btn-primary btn-block"
                        , onClick SaveModel
                        ]
                        [ icon "download"
                        , text <| " Save Team \"" ++ teamName ++ "\""
                        ]
                    ]
                , View.Utils.colPlus [ "md-4", "6" ]
                    [ "mb-2" ]
                    [ button
                        [ class "btn btn-primary btn-block"
                        , onClick Share
                        ]
                        [ icon "share", text " Share" ]
                    ]
                , View.Utils.colPlus [ "md-4", "6" ]
                    [ "mb-2" ]
                    [ button
                        [ class "btn btn-primary btn-block"
                        , onClick Import
                        ]
                        [ icon "upload", text " Import" ]
                    ]
                ]
            , View.Utils.row
                [ View.Utils.colPlus [ "md-4", "12" ]
                    []
                    [ ul
                        []
                        (List.map storageMapper model.storageKeys)
                    ]
                , View.Utils.colPlus [ "md-8", "12" ]
                    []
                    [ textarea
                        [ class "form-control mt-2"
                        , onInput SetImport
                        , rows 15
                        , style [ ( "font-family", "monospace" ) ]
                        ]
                        [ text model.importValue ]
                    ]
                ]
            ]


storageMapper : String -> Html Msg
storageMapper s =
    li []
        [ button
            [ class "btn btn-link", onClick <| LoadModel s ]
            [ text s ]
        , button
            [ class "btn btn-sm btn-danger"
            , onClick <| DeleteItem s
            ]
            [ icon "trash-alt" ]
        ]
