module Model.Vehicles exposing (..)

import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)


type alias Vehicle =
    { name : String
    , vtype : VehicleType
    , gear : GearTracker
    , hazards : Int
    , handling : Int
    , skidResults : List SkidResult
    , hull : HullHolder
    , crew : Int
    , equipment : Int
    , weight : WeightClass
    , activated : Bool
    , weapons : List Weapon
    , upgrades : List Upgrade
    , notes : String
    , cost : Int
    , id : Int
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


type SkidResult
    = Hazard
    | Spin
    | Slide
    | Shift


type alias GearTracker =
    { current : Int
    , max : Int
    }


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
    ]


vehicleCost : Vehicle -> Int
vehicleCost v =
    v.cost + (List.sum <| List.map weaponCost v.weapons) + (List.sum <| List.map .cost v.upgrades)


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


emptyVehicle : VehicleType -> Int -> Vehicle
emptyVehicle vtype index =
    let
        gear =
            GearTracker 1 <| typeToGearMax vtype

        handling =
            typeToHandling vtype

        hull =
            HullHolder 0 (typeToHullMax vtype)

        crew =
            typeToCrewMax vtype

        equipment =
            typeToEquipmentMax vtype

        weight =
            typeToWeight vtype

        cost =
            typeToCost vtype
    in
        Vehicle
            ""
            vtype
            gear
            0
            handling
            []
            hull
            crew
            equipment
            weight
            False
            []
            []
            ""
            cost
            index


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


typeToEquipmentMax : VehicleType -> Int
typeToEquipmentMax t =
    case t of
        Bike ->
            1

        Buggy ->
            2

        Car ->
            2

        PerformanceCar ->
            2

        PickupTruck ->
            3

        MonsterTruck ->
            2

        Bus ->
            3

        WarRig ->
            5

        Tank ->
            4

        Gyrocopter ->
            0

        Helicopter ->
            4


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
