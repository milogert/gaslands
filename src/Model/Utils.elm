module Model.Utils exposing
    ( modToInt
    , totalCrew
    , totalGear
    , totalHandling
    , totalHull
    )

import Model.Shared exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Model exposing (..)


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
