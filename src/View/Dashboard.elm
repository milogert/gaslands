module View.Dashboard exposing (view)

import Bulma.Components exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Dict
import FontAwesome.Icon as Icon
import FontAwesome.Solid as Icon
import Html exposing (Html, div, text)
import Html.Attributes
    exposing
        ( style
        , type_
        )
import Html.Events exposing (onClick)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common as UpgradeC
import Model.Vehicle exposing (..)
import Model.Vehicle.Common as VehicleC exposing (isWrecked)
import Model.Views exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Common as WeaponC
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.PrinterFriendly
import View.Settings
import View.SponsorSelect
import View.Utils exposing (..)
import View.Vehicle


view : Model -> Html Msg
view model =
    let
        display =
            case model.tabOpened of
                Just viewEvent ->
                    case viewEvent of
                        ViewNew type_ ->
                            case type_ of
                                NewVehicle ->
                                    View.NewVehicle.view model

                                NewWeapon key ->
                                    case vehicleFromKey model key of
                                        Nothing ->
                                            text <| "Select a different vehicle (invalid key: " ++ key ++ ")"

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
                                            text <| "Select a different vehicle (invalid key: " ++ key ++ ")"

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
                                    text <| "Select a different vehicle (invalid key: " ++ key ++ ")"

                                Just vehicle ->
                                    View.Vehicle.renderDetails model vehicle

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

                        _ ->
                            text "Serious error, probably trying to view the dashboard in the dashboard"

                Nothing ->
                    text "Select or add a vehicle."

        vehicleTabOpened vehicle =
            Just <| ViewDetails vehicle.key

        unavailableFunc vehicle =
            vehicle.activated || isWrecked vehicle || model.gearPhase > vehicle.gear.current

        available =
            model.vehicles
                |> Dict.values
                |> List.filter (\v -> not (unavailableFunc v))
                |> List.map (\v -> vehicleTab (vehicleTabOpened v == model.tabOpened) v)

        unavailable =
            model.vehicles
                |> Dict.values
                |> List.filter (\v -> unavailableFunc v)
                |> List.map (\v -> vehicleTab (vehicleTabOpened v == model.tabOpened) v)

        addVehicleTab =
            [ tabGen
                (model.tabOpened == (Just <| ViewNew NewVehicle))
                (ViewNew NewVehicle)
                [ Icon.plus |> Icon.viewStyled [ style "margin-right" ".5rem" ]
                , text "New Vehicle"
                ]
            ]
    in
    container []
        [ tabs tabsModifiers
            []
            []
            (available ++ unavailable ++ addVehicleTab)
        , div []
            [ display ]
        ]


tabGen : Bool -> ViewEvent -> List (Html Msg) -> Html Msg
tabGen focused viewEvent display =
    tab focused
        []
        [ onClick <| ViewTab <| viewEvent ]
        display


vehicleTab : Bool -> Vehicle -> Html Msg
vehicleTab focused vehicle =
    tabGen focused
        (ViewDetails vehicle.key)
        [ text vehicle.name ]
