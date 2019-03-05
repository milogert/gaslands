module Model.Vehicle.Common exposing
    ( allVehicles
    , fromVehicleType
    , fromVehicleWeight
    , slotsRemaining
    , slotsUsed
    , strToVT
    , vehicleCost
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.BaseGame
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)


vehicleCost : Vehicle -> Int
vehicleCost v =
    List.sum
        [ v.cost
        , List.sum <| List.map weaponCost v.weapons
        , List.sum <| List.map .cost v.upgrades
        , List.sum <| List.map .cost v.perks
        ]


fromVehicleType : VehicleType -> String
fromVehicleType t =
    case t of
        Bike ->
            "Bike"

        Buggy ->
            "Buggy"

        Car ->
            "Car"

        PerformanceCar ->
            "Performance Car"

        PickupTruck ->
            "Pickup Truck"

        MonsterTruck ->
            "Monster Truck"

        Bus ->
            "Bus"

        WarRig ->
            "War Rig"

        Tank ->
            "Tank"

        Gyrocopter ->
            "Gyrocopter"

        Helicopter ->
            "Helicopter"


strToVT : String -> Maybe VehicleType
strToVT s =
    case s of
        "Bike" ->
            Just Bike

        "Buggy" ->
            Just Buggy

        "Car" ->
            Just Car

        "Performance Car" ->
            Just PerformanceCar

        "Pickup Truck" ->
            Just PickupTruck

        "Monster Truck" ->
            Just MonsterTruck

        "Bus" ->
            Just Bus

        "War Rig" ->
            Just WarRig

        "Tank" ->
            Just Tank

        "Gyrocopter" ->
            Just Gyrocopter

        "Helicopter" ->
            Just Helicopter

        _ ->
            Nothing


fromVehicleWeight : WeightClass -> String
fromVehicleWeight weight =
    case weight of
        Light ->
            "Light"

        Middle ->
            "Middle"

        Heavy ->
            "Heavy"

        Airborne ->
            "Airborne"


slotsUsed : Vehicle -> Int
slotsUsed v =
    List.sum <| List.map .slots v.weapons ++ List.map .slots v.upgrades


slotsRemaining : Vehicle -> Int
slotsRemaining v =
    v.equipment - slotsUsed v


allVehicles : List Vehicle
allVehicles =
    Model.Vehicle.BaseGame.vehicles
