module View.View exposing (view)

import Browser exposing (Document)
import Bulma.CDN exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Components exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Dict
import FontAwesome.Icon as Icon
import FontAwesome.Styles as Icon
import Html
    exposing
        ( Html
        , div
        , node
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , href
        , rel
        )
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common as UpgradeC
import Model.Vehicle exposing (..)
import Model.Vehicle.Common as VehicleC
import Model.Views exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Common as WeaponC
import View.Dashboard
import View.Details
import View.Menu
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.PrinterFriendly
import View.Settings
import View.SponsorSelect
import View.Utils exposing (..)


view : Model -> Document Msg
view model =
    Document
        (viewToStr model)
        [ stylesheet
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
        , displayAlert model
        , section NotSpaced [] [ render model ]
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
        [ View.Menu.brand model
        , navbarMenu model.navOpen
            []
            [ View.Menu.start model
            , View.Menu.end model
            ]
        ]


displayAlert : Model -> Html Msg
displayAlert model =
    let
        msgBody x =
            messageBody [] [ text <| errorToStr x ]
    in
    case List.isEmpty model.error of
        True ->
            div [] []

        False ->
            model.error
                |> List.map msgBody
                |> message { messageModifiers | color = Danger } []
                |> (\m -> container [ class "alert-section" ] [ m ])


render : Model -> Html Msg
render model =
    case model.view of
        ViewDashboard ->
            View.Dashboard.view model

        ViewNew type_ ->
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
                                    |> List.filter
                                        (\x -> x.slots <= VehicleC.slotsRemaining vehicle)
                                )

        ViewDetails key ->
            case vehicleFromKey model key of
                Nothing ->
                    View.Dashboard.view model

                Just vehicle ->
                    View.Details.view model vehicle

        ViewSponsor ->
            View.SponsorSelect.view model

        ViewPrint key ->
            model.vehicles
                |> Dict.get key
                |> Maybe.withDefault defaultVehicle
                |> List.singleton
                |> View.PrinterFriendly.view model

        ViewPrintAll ->
            model.vehicles
                |> Dict.values
                |> View.PrinterFriendly.view model

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
