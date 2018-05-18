module Update.Utils exposing (addUpgrade, addVehicle, addWeapon, deleteVehicle, setTmpVehicleType, updateActivated, updateCrew, updateGear, updateHull, updateNotes)

import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


addVehicle : Model -> ( Model, Cmd Msg )
addVehicle model =
    let
        newv =
            model.tmpVehicle

        newvtype =
            newv.vtype

        oldl =
            model.vehicles
    in
    case ( newv.vtype, newv.name ) of
        ( NoType, _ ) ->
            { model | error = VehicleTypeError :: model.error } ! []

        ( _, "" ) ->
            { model | error = VehicleNameError :: model.error } ! []

        ( _, _ ) ->
            { model
                | view = Overview
                , vehicles = newv :: oldl
                , tmpVehicle = defaultVehicle
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
    in
    { model | tmpVehicle = newtv } ! []


updateActivated : Model -> Int -> Vehicle -> Bool -> ( Model, Cmd Msg )
updateActivated model i v activated =
    let
        pre =
            List.take i model.vehicles

        nv =
            { v | activated = activated }

        post =
            List.drop (i + 1) model.vehicles
    in
    { model | vehicles = pre ++ nv :: post } ! []


updateHull : Model -> Int -> Vehicle -> String -> ( Model, Cmd Msg )
updateHull model i v strCurrent =
    let
        pre =
            List.take i model.vehicles

        nhull =
            v.hull

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | hull = { nhull | current = current } }

        post =
            List.drop (i + 1) model.vehicles

        newView = case model.view of
            Details i v ->
                Details i nv

            _ ->
                model.view
    in
    { model | view = newView, vehicles = pre ++ nv :: post } ! []


updateCrew : Model -> Int -> Vehicle -> String -> ( Model, Cmd Msg )
updateCrew model i v strCurrent =
    let
        pre =
            List.take i model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | crew = current }

        post =
            List.drop (i + 1) model.vehicles
    in
    { model | vehicles = pre ++ nv :: post } ! []


updateGear : Model -> Int -> Vehicle -> String -> ( Model, Cmd Msg )
updateGear model i v strCurrent =
    let
        pre =
            List.take i model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | gear = current }

        post =
            List.drop (i + 1) model.vehicles
    in
    { model | vehicles = pre ++ nv :: post } ! []


updateNotes : Model -> Bool -> Int -> Vehicle -> String -> ( Model, Cmd Msg )
updateNotes model isPreview i v notes =
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
                    List.take i model.vehicles

                nv =
                    { v | notes = notes }

                post =
                    List.drop (i + 1) model.vehicles
            in
            { model | vehicles = pre ++ nv :: post } ! []


addWeapon : Model -> Int -> Vehicle -> ( Model, Cmd Msg )
addWeapon model i v =
    let
        pre =
            List.take i model.vehicles

        nw =
            model.tmpWeapon

        weaponlist =
            v.weapons

        newweaponlist =
            weaponlist ++ [ nw ]

        nv =
            { v | weapons = newweaponlist }

        post =
            List.drop (i + 1) model.vehicles

        newvehicles =
            pre ++ nv :: post
    in
    case nw.wtype of
        NoWeapon ->
            { model | error = [ WeaponTypeError ] } ! []

        _ ->
            { model | view = Details i nv, error = [], vehicles = newvehicles } ! []


addUpgrade : Model -> Int -> Vehicle -> ( Model, Cmd Msg )
addUpgrade model i v =
    let
        pre =
            List.take i model.vehicles

        newUpgrade =
            model.tmpUpgrade

        upgradeList =
            v.upgrades

        newUpgradeList =
            upgradeList ++ [ newUpgrade ]

        nv =
            { v | upgrades = newUpgradeList }

        post =
            List.drop (i + 1) model.vehicles

        newvehicles =
            pre ++ nv :: post
    in
    case newUpgrade.name of
        "" ->
            { model | error = [ UpgradeTypeError ] } ! []

        _ ->
            { model | view = Details i nv, error = [], vehicles = newvehicles } ! []


deleteVehicle : Model -> Int -> ( Model, Cmd Msg)
deleteVehicle model i =
    let
        pre =
            List.take i model.vehicles

        post =
            List.drop (i + 1) model.vehicles

        newvehicles =
            pre ++ post
    in
    { model | view = Overview, vehicles = newvehicles } ! []
