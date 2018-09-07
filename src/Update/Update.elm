module Update.Update exposing (update)

import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)
import Ports.Storage
import Task
import Update.Vehicle
import Update.Weapon
import Update.Upgrade
import Update.Data


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- ROUTING.
        ToOverview ->
            { model
                | view = Overview
                , tmpVehicle = Nothing
                , tmpWeapon = Nothing
                , tmpUpgrade = Nothing
            }
                ! []

        ToDetails v ->
            { model | view = Details v } ! []

        ToNewVehicle ->
            { model | view = AddingVehicle, tmpVehicle = Nothing } ! []

        ToNewWeapon v ->
            { model | view = AddingWeapon v, tmpWeapon = Nothing } ! []

        ToNewUpgrade v ->
            { model | view = AddingUpgrade v, tmpUpgrade = Nothing } ! []

        ToExport ->
            { model | view = ImportExport } ! [ Ports.Storage.getKeys "" ]

        UpdatePointsAllowed s ->
            { model | pointsAllowed = Result.withDefault 0 (String.toInt s) } ! []

        UpdateTeamName s ->
            { model | teamName = Just s } ! []

        -- Vehicle.
        AddVehicle ->
            Update.Vehicle.addVehicle model

        DeleteVehicle v ->
            Update.Vehicle.deleteVehicle model v

        NextGearPhase ->
            let
                weaponFunc =
                    \w -> { w | status = WeaponReady, attackRoll = 0 }

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
            case model.tmpVehicle of
                Just v ->
                    { model | tmpVehicle = Just { v | name = name } } ! []

                Nothing ->
                    model ! []

        TmpVehicleType vtstr ->
            Update.Vehicle.setTmpVehicleType model vtstr

        TmpNotes notes ->
            case model.tmpVehicle of
                Just v ->
                    { model | tmpVehicle = Just { v | notes = notes } } ! []

                Nothing ->
                    model ! []

        UpdateActivated v activated ->
            Update.Vehicle.updateActivated model v activated

        UpdateGear v strCurrent ->
            Update.Vehicle.updateGear model v (String.toInt strCurrent |> Result.withDefault 1)

        ShiftGear v mod min max ->
            Update.Vehicle.updateGear model v <| clamp min max <| v.gear.current + mod

        UpdateHazards v strCurrent ->
            Update.Vehicle.updateHazards model v (String.toInt strCurrent |> Result.withDefault 1)

        ShiftHazards v mod min max ->
            Update.Vehicle.updateHazards model v <| clamp min max <| v.hazards + mod

        UpdateHull v strCurrent ->
            Update.Vehicle.updateHull model v (String.toInt strCurrent |> Result.withDefault 1)

        ShiftHull v mod min max ->
            Update.Vehicle.updateHull model v <| clamp min max <| v.hull.current + mod

        UpdateCrew v strCurrent ->
            Update.Vehicle.updateCrew model v strCurrent

        UpdateEquipment v strCurrent ->
            Update.Vehicle.updateEquipment model v strCurrent

        UpdateNotes isPreview v notes ->
            Update.Vehicle.updateNotes model isPreview v notes

        -- WEAPON.
        AddWeapon v w ->
            Update.Weapon.addWeapon model v w

        DeleteWeapon v w ->
            Update.Weapon.deleteWeapon model v w

        UpdateAmmoUsed v w total strLeft ->
            Update.Weapon.updateAmmoUsed model v w (total - (String.toInt strLeft |> Result.withDefault 1))

        TmpWeaponUpdate name ->
            let
                w =
                    nameToWeapon name
            in
                { model | tmpWeapon = w } ! []

        TmpWeaponMountPoint mountPointStr ->
            let
                mountPoint =
                    strToMountPoint mountPointStr

                w =
                    case model.tmpWeapon of
                        Nothing ->
                            Nothing

                        Just tmpWeapon ->
                            Just { tmpWeapon | mountPoint = mountPoint }
            in
                { model | tmpWeapon = w } ! []
                
        SetWeaponsReady ->
            model ! []

        SetWeaponFired v w ->
            Update.Weapon.setWeaponFired model v w

        RollWeaponDie v w result ->
            Update.Weapon.rollWeaponDie model v w result

        -- UPGRADE.
        AddUpgrade v u ->
            Update.Upgrade.addUpgrade model v u

        DeleteUpgrade v u ->
            Update.Upgrade.deleteUpgrade model v u

        TmpUpgradeUpdate name ->
            let
                u =
                    nameToUpgrade name
            in
                { model | tmpUpgrade = u } ! []

        -- DATA.
        Import ->
            Update.Data.import_ model

        SetImport json ->
            { model | importValue = json } ! []

        Share ->
            Update.Data.share model

        GetStorage value ->
            { model | importValue = value } ! []

        GetStorageKeys keys ->
            { model | storageKeys = keys } ! []

        SetStorageCallback entry ->
            model ! [ Ports.Storage.getKeys "", Task.perform SetImport (Task.succeed entry.value) ]

        SaveModel ->
            Update.Data.saveModel model

        LoadModel key ->
            model ! [ Ports.Storage.get key ]

        DeleteItem key ->
            model ! [ Ports.Storage.delete key ]

        DeleteItemCallback deletedKey ->
            model ! [ Ports.Storage.getKeys "" ]
