module View.Settings exposing (view)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Brands as Icon
import FontAwesome.Icon as Icon
import FontAwesome.Solid as Icon
import Html
    exposing
        ( Html
        , a
        , b
        , div
        , p
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( class
        , for
        , href
        , id
        , placeholder
        , rows
        , style
        , type_
        , value
        )
import Html.Events exposing (onClick, onInput)
import Model.Features
import Model.Model exposing (..)
import Model.Settings exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Common exposing (allVehicles, fromVehicleWeight)
import Model.Weapon.Common exposing (allWeaponsList, fromDice, fromWeaponRange)
import Ports.Storage exposing (StorageEntry)
import View.Settings.SquadGeneration


view : Model -> Html Msg
view model =
    div [] <|
        List.map (\s -> section NotSpaced [] [ s ])
            [ renderGameSettings model
            , renderAppSettings model.settings
            , renderImportExport model
            , renderReferenceSection model.settings
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
            , connectedFields Left
                []
                [ controlText controlInputModifiers
                    [ class "is-expanded" ]
                    [ id "teamName"
                    , onInput UpdateTeamName
                    , value <| Maybe.withDefault "" model.teamName
                    , placeholder "Team Name"
                    ]
                    []
                ]
            , controlButton { buttonModifiers | color = Warning }
                []
                [ onClick <| SettingsMsg NewTeamVersion ]
                [ text "Create New Team Version" ]
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


renderReferenceSection : Settings -> Html Msg
renderReferenceSection settings =
    renderSection "Reference"
        [ controlButton buttonModifiers
            []
            []
            --[ onClick <| SettingsMsg ToggleReferences ]
            [ text "Toggle references" ]
        , dataTable
            "Vehicles"
            [ "Type", "Weight", "Hull", "Handling", "Max Gear", "Crew", "Build Slots", "Special Rules", "Cost", "Category" ]
            (\v ->
                tableRow False
                    []
                    [ tableCell [] [ text v.type_ ]
                    , tableCell [] [ text <| fromVehicleWeight v.weight ]
                    , tableCell [] [ text <| String.fromInt v.hull.max ]
                    , tableCell [] [ text <| String.fromInt v.handling ]
                    , tableCell [] [ text <| String.fromInt v.gear.max ]
                    , tableCell [] [ text <| String.fromInt v.crew ]
                    , tableCell [] [ text <| String.fromInt v.equipment ]
                    , tableCell [] [ text "specials here" ]

                    --, tableCell [] [ text <| String.fromInt v.specials ]
                    , tableCell [] [ text <| String.fromInt v.cost ]
                    , tableCell [] [ text <| fromCategory v.category ]
                    ]
            )
            allVehicles
        , dataTable
            "Weapons"
            [ "Type", "Range", "Attack", "Build Slots", "Special Rules", "Cost", "Sponsor", "Category" ]
            (\weapon ->
                let
                    attack =
                        case weapon.attack of
                            Nothing ->
                                "-"

                            Just dice ->
                                fromDice dice

                    sponsor =
                        case weapon.requiredSponsor of
                            Nothing ->
                                "-"

                            Just s ->
                                s.name
                in
                tableRow False
                    []
                    [ tableCell [] [ text weapon.name ]
                    , tableCell [] [ text <| fromWeaponRange weapon.range ]
                    , tableCell [] [ text attack ]
                    , tableCell [] [ text <| String.fromInt weapon.slots ]
                    , tableCell [] [ text "specials here" ]

                    --, tableCell [] [ text <| String.fromInt v.specials ]
                    , tableCell [] [ text <| String.fromInt weapon.cost ]
                    , tableCell [] [ text sponsor ]
                    , tableCell [] [ text <| fromCategory weapon.category ]
                    ]
            )
            allWeaponsList
        ]


dataTable : String -> List String -> (a -> Html Msg) -> List a -> Html Msg
dataTable name headerList rowFunc data =
    let
        header =
            tableHead []
                [ tableRow True
                    []
                    (List.map (\s -> tableCellHead [] [ text s ]) headerList)
                ]

        body =
            tableBody []
                (List.map rowFunc data)
    in
    div []
        [ title H5
            []
            [ text name ]
        , table tableModifiers
            []
            [ header
            , body
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

        buttonMods =
            { buttonModifiers
                | size = Standard
            }
    in
    renderSection "Import/Export"
        [ columns columnsModifiers
            []
            [ column columnModifiers
                []
                [ buttons Centered
                    []
                    [ button
                        buttonMods
                        [ class "mb-2"
                        , onClick SaveModel
                        ]
                        [ Icon.download |> Icon.viewIcon
                        , text <| " Save Team \"" ++ teamName ++ "\""
                        ]
                    , button
                        buttonMods
                        [ class "mb-2"
                        , onClick <| Share "" ""
                        ]
                        [ Icon.share |> Icon.viewIcon, text " Share" ]
                    , button
                        buttonMods
                        [ class "mb-2"
                        , onClick <| Import "" ""
                        ]
                        [ Icon.upload |> Icon.viewIcon, text " Import" ]
                    ]
                , ul
                    []
                    (model.storageData
                        |> List.map (storageMapper model.storageKey)
                    )
                ]
            , column columnModifiers
                []
                [ controlTextArea
                    controlTextAreaModifiers
                    []
                    [ onInput SetImport
                    , rows 5
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
            , a [ href "https://github.com/milogert/glom" ] [ Icon.github |> Icon.viewIcon ]
            ]
        ]


storageMapper : String -> StorageEntry -> Html Msg
storageMapper currentStorageKey entry =
    let
        display =
            case compare currentStorageKey entry.key of
                EQ ->
                    b [] [ text <| entry.name ++ " (current team)" ]

                _ ->
                    text entry.name
    in
    connectedFields Left
        []
        [ controlButton buttonModifiers
            [ class "is-expanded" ]
            [ class "is-fullwidth"
            , onClick <| LoadModel entry.key
            ]
            [ display ]
        , controlButton { buttonModifiers | color = Success }
            []
            [ onClick <| Import entry.key entry.value ]
            [ Icon.upload |> Icon.viewIcon ]
        , controlButton { buttonModifiers | color = Info }
            []
            [ onClick <| Share entry.key entry.value ]
            [ Icon.share |> Icon.viewIcon ]
        , controlButton { buttonModifiers | color = Danger }
            []
            [ onClick <| DeleteItem entry.key ]
            [ Icon.trashAlt |> Icon.viewIcon ]
        ]
