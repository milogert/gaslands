module View.Settings exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
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
import Html.Attributes
    exposing
        ( class
        , for
        , href
        , style
        )
import Html.Events exposing (onClick, onInput)
import Model.Features
import Model.Model exposing (..)
import Model.Settings exposing (..)
import Model.Shared exposing (..)
import View.Settings.SquadGeneration
import View.Utils exposing (icon, iconb)


view : Model -> Html Msg
view model =
    div [] <|
        List.intersperse
            (hr [] [])
            [ renderGameSettings model
            , renderExpansionSettings model
            , renderAppSettings model.settings
            , renderImportExport model
            , renderAbout
            ]


renderGameSettings : Model -> Html Msg
renderGameSettings model =
    Grid.row []
        [ Grid.col [ Col.md12 ]
            [ h3 [] [ text "Game Settings" ]
            ]
        , Grid.col []
            [ Form.group []
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


renderExpansionSettings : Model -> Html Msg
renderExpansionSettings model =
    let
        expansionCheck : Expansion -> Html Msg
        expansionCheck e =
            Checkbox.checkbox
                [ Checkbox.id <| fromExpansionAbbrev e
                , Checkbox.checked <| List.member e model.settings.expansions.enabled
                , Checkbox.onCheck <| SettingsMsg << EnableExpansion e
                , Checkbox.disabled <| e == BaseGame
                , Checkbox.inline
                ]
                (fromExpansion e)

        expansionChecks : List (Html Msg)
        expansionChecks =
            model.settings.expansions.available
                |> List.map expansionCheck
    in
    Grid.row []
        [ Grid.col [] <|
            [ h3 [] [ text "Expansion Settings" ] ]
                ++ expansionChecks
        ]


renderAppSettings : Settings -> Html Msg
renderAppSettings settings =
    let
        maybeAppSettings =
            [ Model.Features.get
                "feature-generate-team"
                (View.Settings.SquadGeneration.render settings)
            ]
                |> List.filterMap identity

        actualSettings =
            case List.isEmpty maybeAppSettings of
                True ->
                    [ text "Nothing here yet!" ]

                False ->
                    maybeAppSettings
    in
    Grid.row []
        [ Grid.col [ Col.xs12 ] [ h3 [] [ text "App Settings" ] ]
        , Grid.col [ Col.xs12 ] actualSettings
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
            [ Button.button
                [ Button.primary
                , Button.block
                , Button.attrs [ class "mb-2" ]
                , Button.onClick SaveModel
                ]
                [ icon "download"
                , text <| " Save Team \"" ++ teamName ++ "\""
                ]
            ]
        , Grid.col [ Col.md4, Col.xs12 ]
            [ Button.button
                [ Button.primary
                , Button.block
                , Button.attrs [ class "mb-2" ]
                , Button.onClick Share
                ]
                [ icon "share", text " Share" ]
            ]
        , Grid.col [ Col.md4, Col.xs12 ]
            [ Button.button
                [ Button.primary
                , Button.block
                , Button.attrs [ class "mb-2" ]
                , Button.onClick Import
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
        [ Button.button
            [ Button.roleLink, Button.onClick <| LoadModel s ]
            [ text s ]
        , Button.button
            [ Button.danger
            , Button.small
            , Button.onClick <| DeleteItem s
            ]
            [ icon "trash-alt" ]
        ]
