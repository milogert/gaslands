module Update.Update exposing (update)

import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
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
            { model | view = Overview, tmpVehicle = defaultVehicle, tmpWeapon = defaultWeapon } ! []

        ToDetails i v ->
            { model | view = Details i v } ! []

        ToNewVehicle ->
            { model | view = AddingVehicle, tmpVehicle = defaultVehicle } ! []

        ToNewWeapon i v ->
            { model | view = AddingWeapon i v, tmpVehicle = v, vehicleIndex = i, tmpWeapon = defaultWeapon } ! []

        ToNewUpgrade i v ->
            { model | view = AddingUpgrade i v, tmpVehicle = v, vehicleIndex = i, tmpUpgrade = defaultUpgrade } ! []

        -- ADDING.
        AddVehicle ->
            Update.Utils.addVehicle model

        AddWeapon i v ->
            Update.Utils.addWeapon model i v

        AddUpgrade i v ->
            Update.Utils.addUpgrade model i v

        -- UPDATING.
        TmpName name ->
            { model | tmpVehicle = { tv | name = name } } ! []

        TmpVehicleType vtstr ->
            Update.Utils.setTmpVehicleType model vtstr

        TmpNotes notes ->
            { model | tmpVehicle = { tv | notes = notes } } ! []

        UpdateActivated i v activated ->
            Update.Utils.updateActivated model i v activated

        UpdateHull i v strCurrent ->
            Update.Utils.updateHull model i v strCurrent

        UpdateCrew i v strCurrent ->
            Update.Utils.updateCrew model i v strCurrent

        UpdateGear i v strCurrent ->
            Update.Utils.updateGear model i v strCurrent

        UpdateNotes isPreview i v notes ->
            Update.Utils.updateNotes model isPreview i v notes

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
