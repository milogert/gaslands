module View.View exposing (view)

import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Styles as Icon
import Bootstrap.Badge as Badge
import Bootstrap.Utilities.Spacing as Spacing
import Browser exposing (Document)
import Bulma.CDN exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Components exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Dict exposing (Dict)
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
import Model.Routes exposing (NewType(..), Route(..))
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
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
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
                RoutePrint key ->
                    "/details/" ++ key

                _ ->
                    "/"

        backButton =
            button
                { buttonModifiers
                    | disabled = model.view == RouteDashboard
                    , size = Small
                }
                [ href viewToGoTo, attribute "aria-label" "Back Button" ]
                [ View.Utils.icon "arrow-left" ]

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
                , View.Utils.icon "coins"
                ]

        viewDisplay =
            title H4
                --[ style "margin-bottom" "0" ]
                []
                [ text <| viewToStr model ]
    in
    Document
        (viewToStr model)
        [ stylesheet --CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Icon.css
        , nav model
        , node "link"
            [ rel "stylesheet"
            , href "https://use.fontawesome.com/releases/v5.0.13/css/all.css"
            , attribute "integrity" "sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp"
            , attribute "async" "true"
            , attribute "crossorigin" "anonymous"
            ]
            []
        , level
            [ style "margin" "2rem 2rem 1rem 2rem" ]
            [ levelLeft []
                [ levelItem [] [ viewDisplay ] ]
            , levelRight []
                [ levelItem [] [ View.Sponsor.renderBadge model.sponsor ]
                , levelItem [] [ pointsBadge ]
                ]
            ]
        , displayAlert model
        , container [] [ render model ]
        ]


nav : Model -> Html Msg
nav model =
    fixedNavbar
        Bottom
        { navbarModifiers
            | color = Dark
            , transparent = True
        }
        []
        [ navbarBrand []
            (navbarBurger False [] [ span [] [], span [] [], span [] [] ])
            [ navbarItemLink False
                [ href "/" ]
                [ text <| "Team " ++ Maybe.withDefault "NoName" model.teamName ]
            ]
        , navbarMenu False [] [ navbarStart [] (View.Menu.render model) ]
        ]


displayAlert : Model -> Html Msg
displayAlert model =
    model.error
        |> List.map
            (\x ->
                section NotSpaced [] [ pre [] [ text <| errorToStr x ] ]
            )
        |> div []


render : Model -> Html Msg
render model =
    case model.view of
        RouteDashboard ->
            View.Dashboard.view model

        RouteNew type_ ->
            case type_ of
                NewVehicle ->
                    View.NewVehicle.view model

                NewWeapon key ->
                    case vehicleFromKey model key of
                        Nothing ->
                            View.Dashboard.view model

                        Just vehicle ->
                            View.NewWeapon.view
                                model
                                vehicle
                                (WeaponC.allWeaponsList
                                    |> List.filter (expansionFilter model.settings.expansions.enabled)
                                    |> List.filter
                                        (\x -> x.slots <= VehicleC.slotsRemaining vehicle)
                                    |> List.filter
                                        (\x -> x.name /= WeaponC.handgun.name)
                                    |> List.filter
                                        (View.Utils.weaponSponsorFilter model)
                                )

                NewUpgrade key ->
                    case vehicleFromKey model key of
                        Nothing ->
                            View.Dashboard.view model

                        Just vehicle ->
                            View.NewUpgrade.view
                                model
                                vehicle
                                (UpgradeC.allUpgradesList
                                    |> List.filter (expansionFilter model.settings.expansions.enabled)
                                    |> List.filter
                                        (\x -> x.slots <= VehicleC.slotsRemaining vehicle)
                                )

        RouteDetails key ->
            case vehicleFromKey model key of
                Nothing ->
                    View.Dashboard.view model

                Just vehicle ->
                    View.Details.view model vehicle

        RouteSponsor ->
            View.SponsorSelect.view model

        RoutePrint key ->
            model.vehicles
                |> Dict.get key
                |> Maybe.withDefault defaultVehicle
                |> List.singleton
                |> View.PrinterFriendly.view model

        RoutePrintAll ->
            model.vehicles
                |> Dict.values
                |> View.PrinterFriendly.view model

        RouteSettings ->
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
