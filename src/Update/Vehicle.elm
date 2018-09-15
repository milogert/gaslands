module Update.Vehicle exposing (addVehicle, deleteVehicle, setTmpVehicleType, updateActivated, updateGear, updateHazards, updateCrew, updateEquipment, updateHull, updateNotes, rollSkidDice, setPerkInVehicle, getStream, takePhoto, setUrlForVehicle, discardPhoto)

import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Model.Sponsors exposing (..)
import Update.Utils
import Ports.Photo


addVehicle : Model -> ( Model, Cmd Msg )
addVehicle model =
    case model.tmpVehicle of
        Just vehicleTmp ->
            let
                oldl =
                    model.vehicles
            in
                case ( vehicleTmp.vtype, vehicleTmp.name ) of
                    ( _, "" ) ->
                        { model | error = VehicleNameError :: model.error } ! []

                    ( _, _ ) ->
                        { model
                            | view = Overview
                            , vehicles = oldl ++ [ { vehicleTmp | id = List.length oldl } ]
                            , tmpVehicle = Nothing
                            , error = []
                        }
                            ! []

        Nothing ->
            model ! []


setTmpVehicleType : Model -> String -> ( Model, Cmd Msg )
setTmpVehicleType model vtstr =
    let
        name =
            case model.tmpVehicle of
                Just v ->
                    v.name

                Nothing ->
                    ""

        vtype =
            Maybe.withDefault Bike <| strToVT vtstr

        gear =
            GearTracker 1 (typeToGearMax vtype)

        handling =
            typeToHandling vtype

        hull =
            HullHolder 0 (typeToHullMax vtype)

        crew =
            typeToCrewMax vtype

        equipment =
            typeToEquipmentMax vtype

        weight =
            typeToWeight vtype

        weapons =
            case model.tmpVehicle of
                Just v ->
                    v.weapons

                Nothing ->
                    []

        upgrades =
            case model.tmpVehicle of
                Just v ->
                    v.upgrades

                Nothing ->
                    []

        notes =
            case model.tmpVehicle of
                Just v ->
                    v.notes

                Nothing ->
                    ""

        cost =
            typeToCost vtype

        specials =
            typeToSpecials vtype

        requiredSponsor =
            typeToSponsorReq vtype

        newtv =
            Vehicle
                name
                Nothing
                vtype
                gear
                0
                handling
                []
                hull
                crew
                equipment
                weight
                False
                weapons
                upgrades
                notes
                cost
                -1
                specials
                []
                requiredSponsor
    in
        { model | tmpVehicle = Just newtv } ! []


updateActivated : Model -> Vehicle -> Bool -> ( Model, Cmd Msg )
updateActivated model v activated =
    let
        pre =
            List.take v.id model.vehicles

        nv =
            { v | activated = activated }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateGear : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateGear model v newGear =
    let
        newGearTracker =
            GearTracker newGear v.gear.max

        vehicleUpdated =
            { v | gear = newGearTracker }

        newView =
            case model.view of
                Details _ ->
                    Details vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = newView, vehicles = vehiclesList } ! []


updateHazards : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateHazards model v newHazards =
    let
        vehicleUpdated =
            { v | hazards = newHazards }

        newView =
            case model.view of
                Details _ ->
                    Details vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = newView, vehicles = vehiclesList } ! []


updateHull : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateHull model v currentHull =
    let
        pre =
            List.take v.id model.vehicles

        nhull =
            v.hull

        nv =
            { v | hull = { nhull | current = currentHull } }

        post =
            List.drop (v.id + 1) model.vehicles

        newView =
            case model.view of
                Details v ->
                    Details nv

                _ ->
                    model.view
    in
        { model | view = newView, vehicles = pre ++ nv :: post } ! []


updateCrew : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateCrew model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | crew = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateEquipment : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateEquipment model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | equipment = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateNotes : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateNotes model v notes =
    let
        vehiclesNew =
            Update.Utils.replaceAtIndex v.id { v | notes = notes } model.vehicles
    in
        { model | vehicles = vehiclesNew } ! []


updateAmmoUsed : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
updateAmmoUsed model v w used =
    let
        weaponUpdated =
            { w | ammoUsed = used }

        weaponsNew =
            Update.Utils.replaceAtIndex w.id weaponUpdated v.weapons |> Update.Utils.correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


deleteVehicle : Model -> Vehicle -> ( Model, Cmd Msg )
deleteVehicle model v =
    let
        newvehicles =
            Update.Utils.deleteFromList v.id model.vehicles |> Update.Utils.correctIds
    in
        { model | view = Overview, vehicles = newvehicles } ! []


rollSkidDice : Model -> Vehicle -> List SkidResult -> ( Model, Cmd Msg )
rollSkidDice model v skidResults =
    let
        vehicleUpdated =
            { v | skidResults = skidResults }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


replaceWeaponInVehicle : Vehicle -> Weapon -> Vehicle
replaceWeaponInVehicle v w =
    let
        weaponsNew =
            Update.Utils.replaceAtIndex w.id w v.weapons |> Update.Utils.correctIds
    in
        { v | weapons = weaponsNew }


setPerkInVehicle : Model -> Vehicle -> VehiclePerk -> Bool -> ( Model, Cmd Msg )
setPerkInVehicle model v perk isSet =
    let
        perkList =
            case ( isSet, List.member perk v.perks ) of
                ( True, False ) ->
                    perk :: v.perks

                ( False, _ ) ->
                    List.filter (\s -> s /= perk) v.perks

                _ ->
                    v.perks

        vehicleUpdated =
            { v | perks = perkList }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


getStream : Model -> Vehicle -> ( Model, Cmd Msg )
getStream model v =
    model ! [ Ports.Photo.getStream "" ]


takePhoto : Model -> Vehicle -> ( Model, Cmd Msg )
takePhoto model v =
    model ! [ Ports.Photo.takePhoto "" ]


setUrlForVehicle : Model -> Vehicle -> String -> ( Model, Cmd Msg )
setUrlForVehicle model v url =
    let
        vehicleUpdated =
            { v | photo = Just url }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! [ Ports.Photo.destroyStream "" ]


discardPhoto : Model -> Vehicle -> ( Model, Cmd Msg )
discardPhoto model v =
    let
        vehicleUpdated =
            { v | photo = Nothing }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! [ Ports.Photo.getStream "" ]
