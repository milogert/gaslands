module Model.Vehicles exposing (..)

import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)


type alias Vehicle =
    { name : String
    , vtype : VehicleType
    , handling : Int
    , hull : HullHolder
    , crew : Int
    , gear : Int
    , weight : WeightClass
    , activated : Bool
    , weapons : List Weapon
    , upgrades : List Upgrade
    , notes : String
    , cost : Int
    }


type VehicleType
    = Bike
    | Buggy
    | Car
    | PerformanceCar
    | PickupTruck
    | MonsterTruck
    | Bus
    | WarRig
    | Tank
    | Gyrocopter
    | Helicopter
    | NoType


allVehicleTypes : List VehicleType
allVehicleTypes =
    [ Bike
    , Buggy
    , Car
    , PerformanceCar
    , PickupTruck
    , MonsterTruck
    , Bus
    , WarRig
    , Tank
    , Gyrocopter
    , Helicopter
    , NoType
    ]


vehicleCost : Vehicle -> Int
vehicleCost v =
    v.cost + (List.sum <| List.map .cost v.weapons) + (List.sum <| List.map .cost v.upgrades)


type WeightClass
    = Light
    | Middle
    | Heavy
    | Airborne
    | NoWeight


type alias HullHolder =
    { current : Int
    , max : Int
    }



-- Vehicle definitions.


emptyVehicle : VehicleType -> Vehicle
emptyVehicle vtype =
    let
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
    in
    Vehicle "" vtype handling hull crew gear weight False [] [] "" cost


defaultVehicle : Vehicle
defaultVehicle =
    emptyVehicle NoType


typeToWeight : VehicleType -> WeightClass
typeToWeight t =
    case t of
        Bike ->
            Light

        Buggy ->
            Light

        Car ->
            Middle

        PerformanceCar ->
            Middle

        PickupTruck ->
            Middle

        MonsterTruck ->
            Heavy

        Bus ->
            Heavy

        WarRig ->
            Heavy

        Tank ->
            Heavy

        Gyrocopter ->
            Airborne

        Helicopter ->
            Airborne

        _ ->
            NoWeight


typeToCost : VehicleType -> Int
typeToCost t =
    case t of
        Bike ->
            5

        Buggy ->
            5

        Car ->
            12

        PerformanceCar ->
            15

        PickupTruck ->
            15

        MonsterTruck ->
            25

        Bus ->
            30

        WarRig ->
            40

        Tank ->
            40

        Gyrocopter ->
            10

        Helicopter ->
            30

        _ ->
            0


typeToGearMax : VehicleType -> Int
typeToGearMax t =
    case t of
        Bus ->
            3

        Tank ->
            3

        Gyrocopter ->
            3

        PickupTruck ->
            4

        MonsterTruck ->
            4

        WarRig ->
            4

        Helicopter ->
            4

        Car ->
            5

        Bike ->
            6

        Buggy ->
            6

        PerformanceCar ->
            6

        _ ->
            0


typeToCrewMax : VehicleType -> Int
typeToCrewMax t =
    case t of
        Bike ->
            1

        Buggy ->
            2

        Car ->
            2

        PerformanceCar ->
            1

        PickupTruck ->
            3

        MonsterTruck ->
            2

        Bus ->
            8

        WarRig ->
            5

        Tank ->
            3

        Gyrocopter ->
            1

        Helicopter ->
            2

        _ ->
            0


typeToHandling : VehicleType -> Int
typeToHandling t =
    case t of
        Bike ->
            5

        Buggy ->
            4

        Car ->
            3

        PerformanceCar ->
            4

        PickupTruck ->
            2

        MonsterTruck ->
            3

        Bus ->
            2

        WarRig ->
            2

        Tank ->
            4

        Gyrocopter ->
            4

        Helicopter ->
            3

        _ ->
            0


typeToHullMax : VehicleType -> Int
typeToHullMax t =
    case t of
        Bike ->
            4

        Buggy ->
            6

        Car ->
            10

        PerformanceCar ->
            8

        PickupTruck ->
            12

        MonsterTruck ->
            10

        Bus ->
            16

        WarRig ->
            20

        Tank ->
            20

        Gyrocopter ->
            4

        Helicopter ->
            8

        _ ->
            0


vTToStr : VehicleType -> String
vTToStr t =
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

        _ ->
            "No Type"


strToVT : String -> VehicleType
strToVT s =
    case s of
        "Bike" ->
            Bike

        "Buggy" ->
            Buggy

        "Car" ->
            Car

        "Performance Car" ->
            PerformanceCar

        "Pickup Truck" ->
            PickupTruck

        "Monster Truck" ->
            MonsterTruck

        "Bus" ->
            Bus

        "War Rig" ->
            WarRig

        "Tank" ->
            Tank

        "Gyrocopter" ->
            Gyrocopter

        "Helicopter" ->
            Helicopter

        _ ->
            NoType
