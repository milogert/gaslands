module View.Settings exposing (view)

import Bootstrap.Button as Btn
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html
    exposing
        ( Html
        , a
        , div
        , h3
        , h4
        , hr
        , li
        , p
        , text
        , ul
        )
import Html.Attributes exposing (class, classList, for, href, id, placeholder, rows, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Settings exposing (..)
import View.Settings.SquadGeneration
import View.Utils exposing (icon, iconb)


view : Model -> Html Msg
view model =
    div [] <|
        List.intersperse
            (hr [] [])
            [ renderGameSettings model
            , renderAppSettings model.settings
            , renderImportExport model
            , renderAbout
            ]


renderGameSettings : Model -> Html Msg
renderGameSettings model =
    Grid.row []
        [ Grid.col []
            [ h3 [] [ text "Game Settings" ]
            , Form.group []
                [ Form.label [ for "teamName" ] [ text "Team Name" ]
                , Input.text
                    [ Input.id "teamName"
                    , Input.onInput UpdateTeamName
                    , Input.value <| Maybe.withDefault "" model.teamName
                    , Input.placeholder "Team Name"
                    ]
                ]
            , Form.group []
                [ Form.label [ for "squadPoints" ] [ text "Maxiumum Points Allowed" ]
                , Input.number
                    [ Input.id "squadPoints"
                    , Input.value <| String.fromInt model.pointsAllowed
                    , Input.onInput UpdatePointsAllowed
                    ]
                ]
            ]
        ]


renderAppSettings : Settings -> Html Msg
renderAppSettings settings =
    Grid.row []
        [ Grid.col [ Col.xs12 ] [ h3 [] [ text "App Settings" ] ]
        , Grid.col [ Col.xs12 ]
            [ View.Settings.SquadGeneration.render settings ]
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
    Grid.row []
        [ Grid.col [ Col.xs12 ] [ h3 [] [ text "Import/Export" ] ]
        , Grid.col [ Col.md4, Col.xs12 ]
            [ Btn.button
                [ Btn.primary
                , Btn.block
                , Btn.attrs [ class "mb-2" ]
                , Btn.onClick SaveModel
                ]
                [ icon "download"
                , text <| " Save Team \"" ++ teamName ++ "\""
                ]
            ]
        , Grid.col [ Col.md4, Col.xs12 ]
            [ Btn.button
                [ Btn.primary
                , Btn.block
                , Btn.attrs [ class "mb-2" ]
                , Btn.onClick Share
                ]
                [ icon "share", text " Share" ]
            ]
        , Grid.col [ Col.md4, Col.xs12 ]
            [ Btn.button
                [ Btn.primary
                , Btn.block
                , Btn.attrs [ class "mb-2" ]
                , Btn.onClick Import
                ]
                [ icon "upload", text " Import" ]
            ]
        , Grid.col [ Col.xs4 ]
            [ ul
                []
                (List.map storageMapper model.storageKeys)
            ]
        , Grid.col [ Col.xs8 ]
            [ Textarea.textarea
                [ Textarea.onInput SetImport
                , Textarea.rows 15
                , Textarea.attrs [ style "font-family" "monospace" ]
                , Textarea.value model.importValue
                ]
            ]
        ]


renderAbout : Html Msg
renderAbout =
    Grid.row []
        [ Grid.col []
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
        [ Btn.button
            [ Btn.roleLink, Btn.onClick <| LoadModel s ]
            [ text s ]
        , Btn.button
            [ Btn.danger
            , Btn.small
            , Btn.onClick <| DeleteItem s
            ]
            [ icon "trash-alt" ]
        ]
