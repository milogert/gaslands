module Update.Update exposing (update)

import Json.Encode
import Json.Decode
import Model.Decoders.Model exposing (modelDecoder)
import Model.Encoders.Model exposing (modelEncoder)
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
                { model | view = AddingVehicle, tmpVehicle = Nothing } ! []

            ToNewWeapon v ->
                { model | view = AddingWeapon v, tmpWeapon = Nothing } ! []

            ToNewUpgrade v ->
                { model | view = AddingUpgrade v, tmpUpgrade = Nothing } ! []

            ToExport ->
                { model | view = ImportExport } ! []

            -- ADDING.
            AddVehicle ->
                Update.Utils.addVehicle model

            AddWeapon v w ->
                Update.Utils.addWeapon model v w

            AddUpgrade v u ->
                Update.Utils.addUpgrade model v u

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

            UpdateAmmoUsed v w total strLeft ->
                Update.Utils.updateAmmoUsed model v w (total - (String.toInt strLeft |> Result.withDefault 1))

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

            TmpUpgradeUpdate name ->
                let
                    u =
                        nameToUpgrade name
                in
                    { model | tmpUpgrade = u } ! []

            UpdatePointsAllowed s ->
                { model | pointsAllowed = Result.withDefault 0 (String.toInt s) } ! []

            -- STATE MANAGEMENT.
            SetWeaponsReady ->
                model ! []

            SetWeaponFired v w ->
                Update.Utils.setWeaponFired model v w
            
            -- IMPORT/EXPORT.
            Import ->
                let
                    decodeRes = 
                        Json.Decode.decodeString modelDecoder model.importValue

                    newModel : Model
                    newModel = case decodeRes of
                        Ok m ->
                            m

                        Err s ->
                            { model | error = [ JsonDecodeError s ] }
                in
                    { model
                        | view = newModel.view
                        , pointsAllowed = newModel.pointsAllowed 
                        , vehicles = newModel.vehicles
                        , tmpVehicle = newModel.tmpVehicle
                        , tmpWeapon = newModel.tmpWeapon
                        , tmpUpgrade = newModel.tmpUpgrade
                        , error = newModel.error
                        , importValue = newModel.importValue
                    } ! []

            SetImport json ->
                { model | importValue = json } ! []

            Export ->
                model ! [ exportModel <| Json.Encode.encode 4 <| modelEncoder model ]
