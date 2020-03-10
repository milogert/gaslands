module Model.Weapon.Common exposing
    ( allWeaponsList
    , fromDice
    , fromWeaponMounting
    , fromWeaponRange
    , fromWeaponStatus
    , handgun
    , nameToWeapon
    , rollDice
    , strToMountPoint
    , weaponCost
    )

import Dict
import Model.Shared exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Data


handgun : Weapon
handgun =
    Model.Weapon.Data.handgun


fromWeaponMounting : WeaponMounting -> String
fromWeaponMounting point =
    case point of
        Full ->
            "360° mounted"

        Front ->
            "Front mounted"

        LeftSide ->
            "Left mounted"

        RightSide ->
            "Right mounted"

        Rear ->
            "Rear mounted"

        CrewFired ->
            "Crew fired"


strToMountPoint : String -> Maybe WeaponMounting
strToMountPoint point =
    case point of
        "360° mounted" ->
            Just Full

        "Front mounted" ->
            Just Front

        "Left mounted" ->
            Just LeftSide

        "Right mounted" ->
            Just RightSide

        "Rear mounted" ->
            Just Rear

        "Crew fired" ->
            Just CrewFired

        _ ->
            Nothing


fromWeaponRange : Range -> String
fromWeaponRange range =
    case range of
        Short ->
            "Short"

        Medium ->
            "Medium"

        Long ->
            "Long"

        Double ->
            "Double"

        TemplateLarge ->
            "Large"

        BurstRange size ->
            stringFromSize size ++ " Burst"

        SmashRange ->
            "Smash"

        SpecialRange s ->
            "Special: " ++ s

        Dropped ->
            "Dropped"


fromWeaponStatus : WeaponStatus -> String
fromWeaponStatus status =
    case status of
        WeaponReady ->
            "Ready"

        WeaponFired ->
            "Fired"


allWeaponsList : List Weapon
allWeaponsList =
    Model.Weapon.Data.weapons


nameToWeapon : String -> Maybe Weapon
nameToWeapon s =
    allWeaponsList
        |> List.map (\w -> ( w.name, w ))
        |> Dict.fromList
        |> Dict.get s


rollDice : Dice -> Int
rollDice dice =
    -100


fromDice : Dice -> String
fromDice dice =
    String.fromInt dice.number ++ "d" ++ String.fromInt dice.die


weaponCost : Weapon -> Int
weaponCost w =
    let
        baseCost =
            w.cost

        mountModifier =
            case w.mountPoint of
                Just Full ->
                    (*) 3

                _ ->
                    (*) 1

        totalModifier =
            mountModifier << (*) 1
    in
    totalModifier <| baseCost
