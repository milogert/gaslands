module View.ModalHolder exposing (modalHolder)

import Bootstrap.Button as Button
import Bootstrap.Modal as Modal
import Dict
import Html exposing (Html, div, text)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Common as UpgradeC
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Common as VehicleC
import Model.Vehicle.Model as VehicleM
import Model.Weapon.Common as WeaponC
import Model.Weapon.Model exposing (..)
import View.New
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.Settings
import View.SponsorSelect
import View.Upgrade
import View.Utils
import View.Weapon


modalHolder : Model -> Html Msg
modalHolder model =
    let
        currentVehicle =
            case model.view of
                --ViewDetails v ->
                --   v
                _ ->
                    VehicleM.defaultVehicle

        addWeapon =
            View.NewWeapon.view
                model
                currentVehicle
                (WeaponC.allWeaponsList
                    |> List.filter (expansionFilter model.settings.expansions.enabled)
                    |> List.filter
                        (\x -> x.slots <= VehicleC.slotsRemaining currentVehicle)
                    |> List.filter
                        (\x -> x.name /= WeaponC.handgun.name)
                    |> List.filter
                        (View.Utils.weaponSponsorFilter model)
                )

        addUpgrade =
            View.NewUpgrade.view
                model
                currentVehicle
                (UpgradeC.allUpgradesList
                    |> List.filter (expansionFilter model.settings.expansions.enabled)
                    |> List.filter
                        (\x -> x.slots <= VehicleC.slotsRemaining currentVehicle)
                )

        sponsorSelect =
            View.SponsorSelect.view model

        settings =
            View.Settings.view model
    in
    div []
        [ generateModal
            model
            "vehicle"
            (text "Add Vehicle")
            (View.NewVehicle.view model)
            (View.NewVehicle.addButton model.tmpVehicle)
        , generateModal
            model
            "weapon"
            (text <| "New Weapon for " ++ currentVehicle.name)
            addWeapon.body
            addWeapon.button
        , generateModal
            model
            "upgrade"
            (text <| "New Upgrade for " ++ currentVehicle.name)
            addUpgrade.body
            addUpgrade.button
        , generateModalWithClose
            model
            "sponsor"
            (text <| "Select a Team Sponsor")
            sponsorSelect
        , generateModalWithClose
            model
            "settings"
            (text <| "Settings")
            (View.Settings.view model)
        ]


generateModalWithClose : Model -> String -> Html Msg -> Html Msg -> Html Msg
generateModalWithClose model key header body =
    generateModal model
        key
        header
        body
        (Button.button
            [ Button.onClick <| CloseModal key ]
            [ text "Close" ]
        )


generateModal : Model -> String -> Html Msg -> Html Msg -> Html Msg -> Html Msg
generateModal model key header body footer =
    div [] [ text "" ]



{- Modal.config (CloseModal key)
   |> Modal.large
   |> Modal.h3 [] [ header ]
   |> Modal.body [] [ body ]
   |> Modal.footer [] [ footer ]
   |> Modal.view
       (model.modals
           |> Dict.get key
           |> Maybe.withDefault Modal.hidden
       )
-}
