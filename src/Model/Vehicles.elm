module Model.Vehicles exposing (..)

import Model.Shared exposing (..)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)
import Model.Sponsors exposing (..)


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
    , specials : List Special
    , perks : List VehiclePerk
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
    List.sum
        [ v.cost
        , List.sum <| List.map weaponCost v.weapons
        , List.sum <| List.map .cost v.upgrades
        , List.sum <| List.map .cost v.perks
        ]


type WeightClass
    = Light
    | Middle
    | Heavy
    | Airborne


type alias HullHolder =
    { current : Int
    , max : Int
    }


slotsUsed : Vehicle -> Int
slotsUsed v =
    List.sum <| (List.map .slots v.weapons) ++ (List.map .slots v.upgrades)


slotsRemaining : Vehicle -> Int
slotsRemaining v =
    v.equipment - (slotsUsed v)



-- Vehicle definitions.


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


typeToSpecials : VehicleType -> List Special
typeToSpecials type_ =
    case type_ of
        Bike ->
            [ NamedSpecialRule "Full Throttle" "This vehicle considers the long straight maneuver template to be permitted in any gear. The long straight is not considered either hazardous or trivial in any gear."
            , NamedSpecialRule "Pivot" "At the start of this vehicle's activation, if this vehicle's current gar is 1, this vehicle may make a pivot about its centre to face any direction. This pivot cannot cause a collision, and cannot leave this vehicle touching an obstruction."
            ]

        Buggy ->
            [ NamedSpecialRule "Roll Cage" "When this vehicle suffers a flip, this vehicle may choose to ignore the 2 hits received from the flip."
            ]

        PerformanceCar ->
            [ NamedSpecialRule "Slip Away" "If this vehicle is targeted wtih a tailgate, T-bone or sideswipe smash attack, and this vehicle declares evade as its reaction, this vehicle may perform a free activation immediately after tha active vehicle completes its activation."
            , SpecialRule "This free activation does not count as the vehicle's activation this gear phase."
            ]

        MonsterTruck ->
            [ NamedSpecialRule "Big Tires" "This vehicle may ignore the penalty for being on a rough surface, and considers a treacherous surface to be a rough surface."
            , NamedSpecialRule "Crush Attack" "After resolving a collision with a Bike, Buggy, Car, Pickup Truck, Performance Car, Lightweight Obstacle or Middleweight Obstacle during movement step 1.7, this vehicle may ignore the obstruction for the remainder of its movement step, as it drives right over the top of it."
            ]

        WarRig ->
            [ SpecialRule "See Page 52 of the core rulebook." ]

        Helicopter ->
            [ NamedSpecialRule "Air Wolf" "At the start of this vehicle's activation, this vehicle may make a single pivot about its centre point, up to 90 degrees."
            , NamedSpecialRule "Airborne" "This vehicle ignores obstructions, dropped weapons and terrain at all times, except that this vehicle may target other vehicles in its attack step."
            , SpecialRule "Other vehicles ignore this vehicle at all times, except that other vehicles may target this vehicle during their attack steps. This vehicle cannot be involved in collisions."
            , NamedSpecialRule "Bombs Away" "When purchasing weapons, this vehicle may count dropped weapons as requiring 0 build slots."
            ]

        Gyrocopter ->
            [ NamedSpecialRule "Air Wolf" "At the start of this vehicle's activation, this vehicle may make a single pivot about its centre point, up to 90 degrees."
            , NamedSpecialRule "Airborne" "This vehicle ignores obstructions, dropped weapons and terrain at all times, except that this vehicle may target other vehicles in its attack step."
            , SpecialRule "Other vehicles ignore this vehicle at all times, except that other vehicles may target this vehicle during their attack steps. This vehicle cannot be involved in collisions."
            , NamedSpecialRule "Bombs Away" "When purchasing weapons, this vehicle may count dropped weapons as requiring 0 build slots."
            ]

        Tank ->
            [ NamedSpecialRule "Pivot" "At the start of this vehicle's activation, if this vehicle's current gar is 1, this vehicle may make a pivot about its centre to face any direction. This pivot cannot cause a collision, and cannot leave this vehicle touching an obstruction."
            , NamedSpecialRule "Crush Attack" "After resolving a collision with a Bike, Buggy, Car, Pickup Truck, Performance Car, Lightweight Obstacle or Middleweight Obstacle during movement step 1.7, this vehicle may ignore the obstruction for the remainder of its movement step, as it drives right over the top of it."
            , NamedSpecialRule "All Terrain" "This vehicle may ignore the penalties for rough and treacherous surfaces."
            ]

        _ ->
            []
