module View.Settings exposing (view)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Dict exposing (Dict)
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
        , rows
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


renderSection : String -> List (Html Msg) -> Html Msg
renderSection sectionTitle content =
    div [ class "settings-section" ]
        [ title H4
            [ class "settings-section-title" ]
            [ text sectionTitle ]
        , div [ class "settings-section-body" ]
            content
        ]


renderGameSettings : Model -> Html Msg
renderGameSettings model =
    renderSection "Game Settings"
        [ field []
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
    renderSection "Expansion Settings"
        expansionChecks


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
    renderSection "App Settings"
        actualSettings


renderImportExport : Model -> Html Msg
renderImportExport model =
    let
        teamName =
            case model.teamName of
                Nothing ->
                    "NoName"

                Just s ->
                    s

        buttonMods =
            { buttonModifiers
                | size = Standard
            }
    in
    renderSection "Import/Export"
        [ buttons Centered
            []
            [ button
                buttonMods
                [ class "mb-2"
                , onClick SaveModel
                ]
                [ View.Utils.icon "download"
                , text <| " Save Team \"" ++ teamName ++ "\""
                ]
            , button
                buttonMods
                [ class "mb-2"
                , onClick <| Share "" ""
                ]
                [ View.Utils.icon "share", text " Share" ]
            , button
                buttonMods
                [ class "mb-2"
                , onClick <| Import "" ""
                ]
                [ View.Utils.icon "upload", text " Import" ]
            ]
        , columns columnsModifiers
            []
            [ column columnModifiers
                []
                [ ul
                    []
                    (model.storageData
                        |> Dict.toList
                        |> List.map storageMapper
                    )
                ]
            , column columnModifiers
                []
                [ controlTextArea
                    controlTextAreaModifiers
                    []
                    [ onInput SetImport
                    , rows 15
                    , style "font-family" "monospace"
                    , value model.importValue
                    ]
                    []
                ]
            ]
        ]


renderAbout : Html Msg
renderAbout =
    renderSection "About"
        [ p [] [ text "Built by Milo Gertjejansen." ]
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


storageMapper : ( String, String ) -> Html Msg
storageMapper ( key, jsonModel ) =
    connectedFields Left
        []
        [ controlButton buttonModifiers
            []
            [ onClick <| LoadModel key ]
            [ text key ]
        , controlButton { buttonModifiers | color = Success }
            []
            [ onClick <| Import key jsonModel ]
            [ View.Utils.icon "upload" ]
        , controlButton { buttonModifiers | color = Info }
            []
            [ onClick <| Share key jsonModel ]
            [ View.Utils.icon "share" ]
        , controlButton { buttonModifiers | color = Danger }
            []
            [ onClick <| DeleteItem key ]
            [ View.Utils.icon "trash-alt" ]
        ]
