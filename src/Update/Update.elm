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

        ToDetails v ->
            { model | view = Details v } ! []

        ToNewVehicle ->
            { model | view = AddingVehicle, tmpVehicle = defaultVehicle } ! []

        ToNewWeapon v ->
            { model | view = AddingWeapon v, tmpVehicle = v, tmpWeapon = defaultWeapon } ! []

        ToNewUpgrade v ->
            { model | view = AddingUpgrade v, tmpVehicle = v, tmpUpgrade = defaultUpgrade } ! []

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
            { model | tmpVehicle = { tv | name = name } } ! []

        TmpVehicleType vtstr ->
            Update.Utils.setTmpVehicleType model vtstr

        TmpNotes notes ->
            { model | tmpVehicle = { tv | notes = notes } } ! []

        UpdateActivated v activated ->
            Update.Utils.updateActivated model v activated

        UpdateHull v strCurrent ->
            Update.Utils.updateHull model v strCurrent

        UpdateCrew v strCurrent ->
            Update.Utils.updateCrew model v strCurrent

        UpdateGear v strCurrent ->
            Update.Utils.updateGear model v strCurrent

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
