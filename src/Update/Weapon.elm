module Update.Weapon exposing (update)

import Dict exposing (..)
import List.Extra as ListE
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle exposing (..)
import Model.Views exposing (ViewEvent(..))
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)
import Random
import Update.Utils exposing (goTo, goToTab)


update : Model -> WeaponEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        AddWeapon key w ->
            addWeapon model key w

        DeleteWeapon key w ->
            deleteWeapon model key w

        UpdateAmmoUsed key w index check ->
            updateAmmoUsed model key w index check

        TmpWeaponUpdate name ->
            let
                w =
                    nameToWeapon name
            in
            ( { model | tmpWeapon = w }
            , Cmd.none
            )

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
            ( { model | tmpWeapon = w }
            , Cmd.none
            )

        SetWeaponsReady ->
            ( model
            , Cmd.none
            )

        SetWeaponFired v w ->
            setWeaponFired model v w

        RollWeaponDie v w result ->
            rollWeaponDie model v w result


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
            case w.mountPoint of
                Nothing ->
                    ( { model | error = [ WeaponMountPointError ] }
                    , Cmd.none
                    )

                Just mountPoint ->
                    ( { model
                        | error = []
                        , vehicles = Dict.insert key nv model.vehicles
                        , tmpWeapon = Nothing
                      }
                    , Cmd.batch
                        [ goToTab <| ViewDetails key
                        , goTo ViewDashboard
                        ]
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
                | vehicles = Dict.insert key nv model.vehicles
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
                | vehicles = Dict.insert key nv model.vehicles
              }
            , Random.generate (WeaponMsg << RollWeaponDie key weaponUpdated) (Random.int minRoll maxRoll)
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
                | vehicles = Dict.insert key nv model.vehicles
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
                | vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )
