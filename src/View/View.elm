module View.View exposing (view)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Browser exposing (Document)
import Html
    exposing
        ( Html
        , div
        , h2
        , hr
        , node
        , pre
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , classList
        , href
        , rel
        , style
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Common as UpgradeC
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Common as VehicleC
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common as WeaponC
import Model.Weapon.Model exposing (..)
import View.Dashboard
import View.Details
import View.Menu
import View.ModalHolder
import View.New
import View.NewVehicle
import View.PrinterFriendly
import View.Settings
import View.Sponsor
import View.SponsorSelect
import View.Upgrade
import View.Utils exposing (..)
import View.Weapon


view : Model -> Document Msg
view model =
    let
        viewToGoTo =
            case model.view of
                ViewPrinterFriendly lv ->
                    case List.length lv of
                        1 ->
                            To <| ViewDetails <| Maybe.withDefault defaultVehicle <| List.head lv

                        _ ->
                            To ViewDashboard

                _ ->
                    To ViewDashboard

        backButton =
            Button.button
                [ Button.disabled <| model.view == ViewDashboard
                , Button.light
                , Button.small
                , Button.block
                , Button.onClick viewToGoTo
                , Button.attrs [ attribute "aria-label" "Back Button" ]
                ]
                [ icon "arrow-left" ]

        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        pointsBadgeFunction =
            case compare currentPoints maxPoints of
                LT ->
                    Badge.badgeWarning

                EQ ->
                    Badge.badgeSuccess

                GT ->
                    Badge.badgeDanger

        pointsBadge =
            pointsBadgeFunction
                [ class "ml-2" ]
                [ text <| String.fromInt currentPoints ++ " of " ++ String.fromInt maxPoints
                , icon "coins"
                ]

        viewDisplay =
            h2 [ style "margin-bottom" "0" ]
                [ text <| viewToStr model ]
    in
    Document
        (viewToStr model)
        [ Grid.container [ Spacing.mt3 ]
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , node "link"
                [ rel "stylesheet"
                , href "https://use.fontawesome.com/releases/v5.0.13/css/all.css"
                , attribute "integrity" "sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp"
                , attribute "async" "true"
                , attribute "crossorigin" "anonymous"
                ]
                []
            , Grid.simpleRow
                [ View.Menu.side model
                , View.Menu.top model
                , Grid.col []
                    [ Grid.row [ Row.attrs [ Spacing.mb2 ] ]
                        [ Grid.col [] [ viewDisplay ]
                        , Grid.col
                            [ Col.xs12
                            , Col.mdAuto
                            ]
                            [ View.Sponsor.renderBadge model.sponsor
                            , pointsBadge
                            ]
                        ]
                    , Grid.simpleRow
                        [ Grid.col []
                            [ displayAlert model
                            , render model
                            , View.ModalHolder.modalHolder model
                            ]
                        ]
                    ]
                ]
            ]
        ]


displayAlert : Model -> Html Msg
displayAlert model =
    model.error
        |> List.map
            (\x ->
                Grid.simpleRow [ Grid.col [] [ pre [] [ text <| errorToStr x ] ] ]
            )
        |> div []


render : Model -> Html Msg
render model =
    case model.view of
        ViewDashboard ->
            View.Dashboard.view model

        ViewDetails v ->
            View.Details.view model v

        ViewPrinterFriendly lv ->
            View.PrinterFriendly.view model lv

        ViewSettings ->
            View.Settings.view model


sizeShower : Html Msg
sizeShower =
    div []
        [ span
            [ class "d-sm-none d-md-none d-lg-none d-xl-none" ]
            [ text "xs" ]
        , span
            [ class "d-sm-inline d-md-none d-lg-none d-xl-none" ]
            [ text "sm" ]
        , span
            [ class "d-sm-none d-md-inline d-lg-none d-xl-none" ]
            [ text "md" ]
        , span
            [ class "d-sm-none d-md-none d-lg-inline d-xl-none" ]
            [ text "lg" ]
        , span
            [ class "d-sm-none d-md-none d-lg-none d-xl-inline" ]
            [ text "xl" ]
        ]
