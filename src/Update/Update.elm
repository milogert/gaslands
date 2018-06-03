module Update.Update exposing (update)

import Debug exposing (..)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)
import Update.Utils


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        tv =
            model.tmpVehicle
    in
        case msg of
            -- ROUTING.
            ToOverview ->
                { model | view = Overview, tmpVehicle = Nothing, tmpWeapon = Nothing, tmpUpgrade = Nothing } ! []

            ToDetails v ->
                { model | view = Details v } ! []

            ToNewVehicle ->
                { model | view = AddingVehicle } ! []

            ToNewWeapon v ->
                { model | view = AddingWeapon v } ! []

            ToNewUpgrade v ->
                { model | view = AddingUpgrade v } ! []

            -- ADDING.
            AddVehicle ->
                Update.Utils.addVehicle model

            AddWeapon v ->
                Update.Utils.addWeapon model v

            AddUpgrade v ->
                Update.Utils.addUpgrade model v

            -- DELETING.
            DeleteVehicle v ->
                Update.Utils.deleteVehicle model v

            DeleteWeapon v w ->
                Update.Utils.deleteWeapon model v w

            DeleteUpgrade v u ->
                Update.Utils.deleteUpgrade model v u

            -- UPDATING.
            NextGearPhase ->
                let
                    weaponFunc =
                        \w -> { w | status = WeaponReady }

                    vehicleFunc =
                        \v -> { v | weapons = v.weapons |> List.map weaponFunc }

                    vs =
                        model.vehicles
                            |> List.map vehicleFunc
                            |> List.map (\v -> { v | activated = False })

                    gearPhase =
                        if model.gearPhase < 6 then
                            model.gearPhase + 1
                        else
                            1
                in
                    { model
                        | view = Overview
                        , gearPhase = gearPhase
                        , vehicles = vs
                    }
                        ! []

            TmpName name ->
                case tv of
                    Just v ->
                        { model | tmpVehicle = Just { v | name = name } } ! []

                    Nothing ->
                        model ! []

            TmpVehicleType vtstr ->
                Update.Utils.setTmpVehicleType model vtstr

            TmpNotes notes ->
                case tv of
                    Just v ->
                        { model | tmpVehicle = Just { v | notes = notes } } ! []

                    Nothing ->
                        model ! []

            UpdateActivated v activated ->
                Update.Utils.updateActivated model v activated

            UpdateGear v strCurrent ->
                Update.Utils.updateGear model v (String.toInt strCurrent |> Result.withDefault 1)

            UpdateHazards v strCurrent ->
                Update.Utils.updateHazards model v (String.toInt strCurrent |> Result.withDefault 1)

            UpdateHull v strCurrent ->
                Update.Utils.updateHull model v strCurrent

            UpdateCrew v strCurrent ->
                Update.Utils.updateCrew model v strCurrent

            UpdateEquipment v strCurrent ->
                Update.Utils.updateEquipment model v strCurrent

            UpdateNotes isPreview v notes ->
                Update.Utils.updateNotes model isPreview v notes

            TmpWeaponUpdate name ->
                let
                    w =
                        nameToWeapon name
                in
                    { model | tmpWeapon = Just w } ! []

            TmpWeaponMountPoint mountPointStr ->
                let
                    mountPoint =
                        log "stringified" <| strToMountPoint (log "string point" mountPointStr)

                    w =
                        case (log "weapon" model.tmpWeapon) of
                            Nothing ->
                                Nothing

                            Just tmpWeapon ->
                                Just { tmpWeapon | mountPoint = mountPoint }
                in
                    { model | tmpWeapon = (log "setting weapon" w) } ! []

            TmpUpgradeUpdate name ->
                let
                    u =
                        nameToUpgrade name
                in
                    { model | tmpUpgrade = Just u } ! []

            UpdatePointsAllowed s ->
                { model | pointsAllowed = Result.withDefault 0 (String.toInt s) } ! []

            -- STATE MANAGEMENT.
            SetWeaponsReady ->
                model ! []

            SetWeaponFired v w ->
                Update.Utils.setWeaponFired model v w
