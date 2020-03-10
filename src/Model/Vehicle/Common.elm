module Model.Vehicle.Common exposing
    ( allVehicles
    , fromVehicleWeight
    , isWrecked
    , slotsRemaining
    , slotsUsed
    , totalCrew
    , totalGear
    , totalHandling
    , totalHull
    , totalSlots
    , vehicleCost
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Vehicle exposing (..)
import Model.Vehicle.Data
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)


modToInt : Special -> Int
modToInt s =
    case s of
        HandlingMod i ->
            i

        HullMod i ->
            i

        GearMod i ->
            i

        CrewMod i ->
            i

        SlotMod i ->
            i

        _ ->
            0


totalForModType : List Upgrade -> (Special -> Bool) -> Int
totalForModType upgradeList modFilter =
    upgradeList
        |> List.map .specials
        |> List.concat
        |> List.filter modFilter
        |> List.map modToInt
        |> List.sum


totalHandling : Vehicle -> Int
totalHandling v =
    let
        handlingFilter : Special -> Bool
        handlingFilter m =
            case m of
                HandlingMod _ ->
                    True

                _ ->
                    False
    in
    v.handling + totalForModType v.upgrades handlingFilter


totalHull : Vehicle -> Int
totalHull v =
    let
        hullFilter m =
            case m of
                HullMod _ ->
                    True

                _ ->
                    False
    in
    v.hull.max + totalForModType v.upgrades hullFilter


totalGear : Vehicle -> Int
totalGear v =
    let
        gearFilter m =
            case m of
                GearMod _ ->
                    True

                _ ->
                    False
    in
    v.gear.max
        + totalForModType v.upgrades gearFilter
        |> clamp 1 6


totalCrew : Vehicle -> Int
totalCrew v =
    let
        crewFilter m =
            case m of
                CrewMod _ ->
                    True

                _ ->
                    False
    in
    v.crew + totalForModType v.upgrades crewFilter


totalSlots : Vehicle -> Int
totalSlots v =
    let
        slotFilter m =
            case m of
                SlotMod _ ->
                    True

                _ ->
                    False
    in
    v.equipment + totalForModType v.upgrades slotFilter


isWrecked : Vehicle -> Bool
isWrecked v =
    v.hull.current >= totalHull v


vehicleCost : Vehicle -> Int
vehicleCost v =
    List.sum
        [ v.cost
        , List.sum <| List.map weaponCost v.weapons
        , List.sum <| List.map .cost v.upgrades
        , List.sum <| List.map .cost v.perks
        ]


fromVehicleWeight : WeightClass -> String
fromVehicleWeight weight =
    case weight of
        Light ->
            "Light"

        Middle ->
            "Middle"

        Heavy ->
            "Heavy"


slotsUsed : Vehicle -> Int
slotsUsed v =
    List.sum <| List.map .slots v.weapons ++ List.map .slots v.upgrades


slotsRemaining : Vehicle -> Int
slotsRemaining v =
    v.equipment - slotsUsed v


allVehicles : List Vehicle
allVehicles =
    Model.Vehicle.Data.vehicles
