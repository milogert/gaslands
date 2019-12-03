module View.Settings exposing (view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Html
    exposing
        ( Html
        , a
        , div
        , hr
        , li
        , p
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( checked
        , class
        , for
        , href
        , id
        , placeholder
        , style
        , type_
        , value
        )
import Html.Events exposing (onCheck, onClick, onInput)
import Model.Features
import Model.Model exposing (..)
import Model.Settings exposing (..)
import Model.Shared exposing (..)
import View.Settings.SquadGeneration
import View.Utils exposing (icon, iconb)


view : Model -> Html Msg
view model =
    div [] <|
        List.map (\s -> section NotSpaced [] [ s ])
            [ renderGameSettings model
            , renderExpansionSettings model
            , renderAppSettings model.settings
            , renderImportExport model
            , renderAbout
            ]


renderGameSettings : Model -> Html Msg
renderGameSettings model =
    div []
        [ title H4 [] [ text "Game Settings" ]
        , field []
            [ controlLabel [ for "teamName" ] [ text "Team Name" ]
            , controlText
                controlInputModifiers
                []
                [ id "teamName"
                , onInput UpdateTeamName
                , value <| Maybe.withDefault "" model.teamName
                , placeholder "Team Name"
                ]
                []
            ]
        , field []
            [ controlLabel [ for "squadPoints" ] [ text "Maxiumum Points Allowed" ]
            , controlInput
                controlInputModifiers
                []
                [ id "squadPoints"
                , type_ "number"
                , value <| String.fromInt model.pointsAllowed
                , onInput UpdatePointsAllowed
                ]
                []
            ]
        ]


renderExpansionSettings : Model -> Html Msg
renderExpansionSettings model =
    let
        expansionCheck : Expansion -> Html Msg
        expansionCheck e =
            controlCheckBox
                (e == BaseGame)
                []
                []
                [ id <| fromExpansionAbbrev e
                , checked <| List.member e model.settings.expansions.enabled
                , onCheck <| SettingsMsg << EnableExpansion e
                ]
                [ text <| fromExpansion e ]

        expansionChecks : List (Html Msg)
        expansionChecks =
            model.settings.expansions.available
                |> List.map expansionCheck
    in
    div []
        [ title H4 [] [ text "Expansion Settings" ] ]
        ++ expansionChecks


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
    div []
        [ title H4 [] [ text "App Settings" ] ]
        ++ actualSettings


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
    div []
        [ title H4 [] [ text "Import/Export" ]
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
            [ title H4 [] [ text "About" ]
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
