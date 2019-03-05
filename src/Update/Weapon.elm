module Update.Weapon exposing
    ( addWeapon
    , deleteWeapon
    , rollAttackDice
    , rollWeaponDie
    , setWeaponFired
    , updateAmmoUsed
    )

import Dict exposing (..)
import List.Extra as ListE
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Model exposing (..)
import Random
import Update.Utils exposing (doSaveModel)


addWeapon : Model -> String -> Weapon -> ( Model, Cmd Msg )
addWeapon model key w =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                weaponList =
                    vehicle.weapons ++ [ w ]

                nv =
                    { vehicle | weapons = weaponList }
            in
            case ( w.wtype, w.mountPoint ) of
                ( _, Nothing ) ->
                    ( { model | error = [ WeaponMountPointError ] }
                    , Cmd.none
                    )

                ( _, _ ) ->
                    ( { model
                        | view = ViewDetails nv
                        , error = []
                        , vehicles = Dict.insert key nv model.vehicles
                      }
                    , doSaveModel
                    )


updateAmmoUsed : Model -> String -> Weapon -> Int -> Bool -> ( Model, Cmd Msg )
updateAmmoUsed model key weapon index check =
    let
        ( mAmmoSpecialIndex, mAmmoSpecial ) =
            Model.Shared.getAmmoClip weapon.specials
    in
    case ( mAmmoSpecial, mAmmoSpecialIndex, Dict.get key model.vehicles ) of
        ( Just (Ammo clip), Just ammoIndex, Just vehicle ) ->
            let
                ammoUpdated =
                    Ammo <| ListE.setAt index check clip

                specialsUpdated =
                    ListE.setAt ammoIndex ammoUpdated weapon.specials

                weaponUpdated =
                    { weapon | specials = specialsUpdated }

                weaponsNew =
                    ListE.setIf (\wil -> weapon == wil) weaponUpdated vehicle.weapons

                nv =
                    { vehicle | weapons = weaponsNew }
            in
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )

        ( _, _, _ ) ->
            ( model, Cmd.none )


setWeaponFired : Model -> String -> Weapon -> ( Model, Cmd Msg )
setWeaponFired model key w =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                weaponUpdated =
                    { w | status = WeaponFired }

                weaponsNew =
                    ListE.setIf (\wil -> w == wil) weaponUpdated vehicle.weapons

                nv =
                    { vehicle | weapons = weaponsNew }

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
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Random.generate (RollWeaponDie key weaponUpdated) (Random.int minRoll maxRoll)
            )


rollWeaponDie : Model -> String -> Weapon -> Int -> ( Model, Cmd Msg )
rollWeaponDie model key w result =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                weaponUpdated =
                    { w | attackRoll = result }

                newWeapons =
                    ListE.setIf (\wil -> w == wil) weaponUpdated vehicle.weapons

                nv =
                    { vehicle | weapons = newWeapons }
            in
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


deleteWeapon : Model -> String -> Weapon -> ( Model, Cmd Msg )
deleteWeapon model key w =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                weaponsNew =
                    vehicle.weapons
                        |> ListE.remove w

                nv =
                    { vehicle | weapons = weaponsNew }
            in
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , doSaveModel
            )


rollAttackDice : Model -> String -> Weapon -> ( Model, Cmd Msg )
rollAttackDice model key w =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            ( model
            , Cmd.none
            )
