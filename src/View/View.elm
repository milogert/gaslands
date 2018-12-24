module View.View exposing (view)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Btn
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Browser exposing (Document)
import Html
    exposing
        ( Html
        , div
        , h2
        , hr
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , classList
        , style
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Dashboard
import View.Details
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.Settings
import View.Sponsor
import View.SponsorSelect
import View.Utils exposing (..)


view : Model -> Document Msg
view model =
    let
        viewToGoTo =
            case model.view of
                ViewAddingWeapon v ->
                    To <| ViewDetails v

                ViewAddingUpgrade v ->
                    To <| ViewDetails v

                _ ->
                    To ViewDashboard

        backButton =
            Btn.button
                [ Btn.disabled <| model.view == ViewDashboard
                , Btn.light
                , Btn.small
                , Btn.block
                , Btn.onClick viewToGoTo
                , Btn.attrs [ attribute "aria-label" "Back Button" ]
                ]
                [ icon "arrow-left" ]

        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        gearPhaseText =
            String.fromInt model.gearPhase

        gearPhaseButton =
            Btn.button
                [ Btn.small
                , Btn.primary
                , Btn.attrs [ class "ml-2" ]
                , Btn.onClick <| VehicleMsg NextGearPhase
                ]
                [ icon "cogs", Badge.badgeLight [] [ text gearPhaseText ] ]

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

        settingsButton =
            Btn.button
                [ Btn.small
                , Btn.light
                , Btn.onClick <| To ViewSettings
                , Btn.attrs
                    [ attribute "aria-label" "Back Button"
                    , class "ml-2"
                    ]
                ]
                [ icon "wrench" ]

        viewDisplay =
            h2 [ style "margin-bottom" "0" ]
                [ text <| viewToStr model ]
    in
    Document
        (viewToStr model)
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row
                [ Row.middleXs
                , Row.attrs [ class "my-2" ]
                ]
                [ Grid.col [ Col.xsAuto ] [ backButton ]
                , Grid.col [] [ viewDisplay ]
                , Grid.col
                    [ Col.xs12
                    , Col.mdAuto
                    ]
                    [ View.Sponsor.renderBadge model.sponsor
                    , gearPhaseButton
                    , pointsBadge
                    , settingsButton
                    ]
                ]

            --, hr [] []
            , displayAlert model
            , render model

            --, sizeShower
            ]
        ]


displayAlert : Model -> Html Msg
displayAlert model =
    model.error
        |> List.map
            (\x ->
                Grid.simpleRow [ Grid.col [] [ text <| errorToStr x ] ]
            )
        |> div []


render : Model -> Html Msg
render model =
    case model.view of
        ViewDashboard ->
            View.Dashboard.view model

        ViewDetails v ->
            View.Details.view model v

        ViewSelectingSponsor ->
            View.SponsorSelect.view model

        ViewAddingVehicle ->
            View.NewVehicle.view model

        ViewAddingWeapon v ->
            View.NewWeapon.view model v

        ViewAddingUpgrade v ->
            View.NewUpgrade.view model v

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
