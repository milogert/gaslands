module Update.Update exposing (update)

import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)
import Ports.Ports exposing (..)
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

        ToExport ->
            { model | view = ImportExport } ! []

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
            { model | tmpWeapon = w } ! []

        TmpUpgradeUpdate name ->
            let
                u =
                    nameToUpgrade name
            in
            { model | tmpUpgrade = u } ! []

        UpdatePointsAllowed s ->
            { model | pointsAllowed = Result.withDefault 0 (String.toInt s) } ! []

        Export ->
            model ! [ exportModel <| toString model ]
