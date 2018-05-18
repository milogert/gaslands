module Update.Utils exposing (addUpgrade, addVehicle, addWeapon, deleteVehicle, deleteWeapon, deleteUpgrade, setTmpVehicleType, updateActivated, updateCrew, updateGear, updateHull, updateNotes)

import Debug exposing (log)

import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Model.Upgrades exposing (..)


(!!) : Int -> List a -> Maybe a
(!!) n xs  = 
    log "to get" (List.head <| List.drop n xs)


addVehicle : Model -> ( Model, Cmd Msg )
addVehicle model =
    let
        vehicleNew =
            model.tmpVehicle

        oldl =
            model.vehicles

        newId =
            model.autoIncrement + 1
    in
    case ( vehicleNew.vtype, vehicleNew.name ) of
        ( NoType, _ ) ->
            { model | error = VehicleTypeError :: model.error } ! []

        ( _, "" ) ->
            { model | error = VehicleNameError :: model.error } ! []

        ( _, _ ) ->
            { model
                | view = Overview
                , vehicles = oldl ++ [ { vehicleNew | id = model.autoIncrement } ]
                , tmpVehicle = defaultVehicle
                , autoIncrement = newId 
                , error = []
            }
                ! []


setTmpVehicleType : Model -> String -> ( Model, Cmd Msg )
setTmpVehicleType model vtstr =
    let
        vtype =
            strToVT vtstr

        handling =
            typeToHandling vtype

        hull =
            HullHolder 0 (typeToHullMax vtype)

        crew =
            typeToCrewMax vtype

        gear =
            typeToGearMax vtype

        weight =
            typeToWeight vtype

        cost =
            typeToCost vtype

        newtv =
            Vehicle
                model.tmpVehicle.name
                vtype
                handling
                hull
                crew
                gear
                weight
                False
                model.tmpVehicle.weapons
                model.tmpVehicle.upgrades
                model.tmpVehicle.notes
                cost
                -1
    in
    { model | tmpVehicle = newtv } ! []


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


updateHull : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateHull model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        nhull =
            v.hull

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | hull = { nhull | current = current } }

        post =
            List.drop (v.id + 1) model.vehicles

        newView = case model.view of
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


updateGear : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateGear model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | gear = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
    { model | vehicles = pre ++ nv :: post } ! []


updateNotes : Model -> Bool -> Vehicle -> String -> ( Model, Cmd Msg )
updateNotes model isPreview v notes =
    case isPreview of
        True ->
            let
                tmpVehicle =
                    { v | notes = notes }
            in
            { model | tmpVehicle = { v | notes = notes } } ! []

        False ->
            let
                pre =
                    List.take v.id model.vehicles

                nv =
                    { v | notes = notes }

                post =
                    List.drop (v.id + 1) model.vehicles
            in
            { model | vehicles = pre ++ nv :: post } ! []


addWeapon : Model -> Vehicle -> ( Model, Cmd Msg )
addWeapon model v =
    let
        nw =
            model.tmpWeapon

        weaponlist =
            v.weapons

        newweaponlist =
            weaponlist ++ [ nw ]

        nv =
            { v | weapons = newweaponlist }

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        newvehicles =
            pre ++ nv :: post
    in
    case nw.wtype of
        NoWeapon ->
            { model | error = [ WeaponTypeError ] } ! []

        _ ->
            { model | view = Details nv, error = [], vehicles = newvehicles } ! []


addUpgrade : Model -> Vehicle -> ( Model, Cmd Msg )
addUpgrade model v =
    let
        newUpgrade =
            model.tmpUpgrade

        upgradeList =
            v.upgrades

        newUpgradeList =
            upgradeList ++ [ newUpgrade ]

        nv =
            { v | upgrades = newUpgradeList }

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        newvehicles =
            pre ++ nv :: post
    in
    case newUpgrade.name of
        "" ->
            { model | error = [ UpgradeTypeError ] } ! []

        _ ->
            { model | view = Details nv, error = [], vehicles = newvehicles } ! []


deleteVehicle : Model -> Vehicle -> ( Model, Cmd Msg)
deleteVehicle model v =
    let
        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        newvehicles =
            pre ++ post
    in
    { model | view = Overview, vehicles = newvehicles } ! []


deleteWeapon : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg)
deleteWeapon model v w =
    let
        weaponsNew =
            deleteFromList w.id v.weapons

        vehiclesPre =
            List.take v.id model.vehicles

        vehiclesPost =
            List.drop (v.id + 1) model.vehicles

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            vehiclesPre ++ vehicleUpdated ::  vehiclesPost
    in
    { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


deleteUpgrade : Model -> Vehicle -> Upgrade -> ( Model, Cmd Msg )
deleteUpgrade model v u=
    let
        upgradesNew =
            deleteFromList u.id v.upgrades

        vehiclesPre =
            List.take v.id model.vehicles

        vehiclesPost =
            List.drop (v.id + 1) model.vehicles

        vehicleUpdated =
            { v | upgrades = upgradesNew }

        vehiclesNew =
            vehiclesPre ++ vehicleUpdated ::  vehiclesPost
    in
    { model | view = Details vehicleUpdated, vehicles = vehiclesNew  } ! []


deleteFromList : Int -> List a -> List a
deleteFromList index list =
    (List.take index list) ++ (List.drop (index + 1) list)
