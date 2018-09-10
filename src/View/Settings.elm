module View.Settings exposing (view)

import Html exposing (Html, button, div, h3, text, textarea, ul, li, a, label, input, hr, p)
import Html.Attributes exposing (class, rows, style, href, for, classList, type_, id, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon, iconb)


view : Model -> Html Msg
view model =
    div [] <|
        List.intersperse
            (hr [] [])
            [ renderGameSettings model.pointsAllowed
            , renderImportExport model
            , renderAbout
            ]


renderGameSettings : Int -> Html Msg
renderGameSettings pointsAllowed =
    View.Utils.row
        [ View.Utils.col "12"
            [ h3 [] [ text "Game Settings" ]
            , div [ class "form-group" ]
                [ label
                    [ for "squadPoints"
                    , class "col-form-label mr-2"
                    ]
                    [ text "Maxiumum Points Allowed" ]
                , div
                    [ class "input-group mb-0 mr-4" ]
                    [ input
                        [ type_ "number"
                        , class "form-control my-1"
                        , id "squadPoints"
                        , value <| toString pointsAllowed
                        , onInput UpdatePointsAllowed
                        ]
                        []
                    ]
                ]
            ]
        ]


renderImportExport : Model -> Html Msg
renderImportExport model =
    let
        teamName =
            case model.teamName of
                Nothing ->
                    "NoName"

                Just s ->
                    s
    in
        View.Utils.row
            [ View.Utils.col "12" [ h3 [] [ text "Import/Export" ] ]
            , View.Utils.colPlus [ "md-4", "12" ]
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
            , View.Utils.colPlus [ "md-4", "12" ]
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


renderAbout : Html Msg
renderAbout =
    View.Utils.row
        [ View.Utils.col "12"
            [ h3 [] [ text "About" ]
            , p [] [ text "Built by Milo Gertjejansen." ]
            , p [] [ text "Email: milo plus glom at milogert dot com" ]
            , p []
                [ text "Built with "
                , a [ href "http://elm-lang.org" ]
                    [ text "Elm" ]
                , text "."
                ]
            , p []
                [ text "Check out the "
                , a [ href "https://github.com/milogert/glom" ] [ iconb "github" ]
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
