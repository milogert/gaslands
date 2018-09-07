module Update.Weapon exposing (addWeapon, deleteWeapon, setWeaponFired, updateAmmoUsed, rollAttackDice, rollWeaponDie)

import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Random
import Update.Utils


addWeapon : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
addWeapon model v w =
    let
        weaponList =
            v.weapons ++ [ { w | id = List.length v.weapons } ]

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        vehicleNew =
            { v | weapons = weaponList }

        newvehicles =
            pre ++ vehicleNew :: post
    in
        case ( w.wtype, w.mountPoint ) of
            ( _, Nothing ) ->
                { model | error = [ WeaponMountPointError ] } ! []

            ( _, _ ) ->
                { model | view = Details vehicleNew, error = [], vehicles = newvehicles } ! []


updateAmmoUsed : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
updateAmmoUsed model v w used =
    let
        weaponUpdated =
            { w | ammoUsed = used }

        weaponsNew =
            Update.Utils.joinAround w.id weaponUpdated v.weapons |> Update.Utils.correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            Update.Utils.joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


setWeaponFired : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
setWeaponFired model v w =
    let
        weaponUpdated =
            { w | status = WeaponFired }

        weaponsNew =
            Update.Utils.joinAround w.id weaponUpdated v.weapons |> Update.Utils.correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            Update.Utils.joinAround v.id vehicleUpdated model.vehicles

        minRoll =
            case weaponUpdated.attack of
                Just dice ->
                    dice.number

                Nothing ->
                    0

        maxRoll =
            case weaponUpdated.attack of
                Just dice ->
                    dice.number * dice.die

                Nothing ->
                    0
    in
        { model
            | view = Details vehicleUpdated
            , vehicles = vehiclesNew
        }
            ! [ Random.generate (RollWeaponDie v weaponUpdated) (Random.int minRoll maxRoll) ]


rollWeaponDie : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
rollWeaponDie model v w result =
    let
        weaponUpdated =
            { w | attackRoll = result }

        vehicleUpdated =
            Update.Utils.replaceWeaponInVehicle v weaponUpdated

        vehiclesNew =
            Update.Utils.joinAround v.id vehicleUpdated model.vehicles
    in
        { model
            | view = Details vehicleUpdated
            , vehicles = vehiclesNew
        }
            ! []


deleteWeapon : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
deleteWeapon model v w =
    let
        weaponsNew =
            Update.Utils.deleteFromList w.id v.weapons |> Update.Utils.correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            Update.Utils.joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []



rollAttackDice : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
rollAttackDice model v w =
    model ! []
