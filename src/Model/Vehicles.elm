module Model.Vehicles exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)


type alias Vehicle =
    { name : String
    , vtype : VehicleType
    , gear : GearTracker
    , handling : Int
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
    

vehicleDecoder : Decoder Vehicle
vehicleDecoder =
    decode Vehicle
        |> required "name" D.string
        |> required "vtype" vtypeDecoder
        |> required "gearTracker" gearDecoder
        |> required "handling" D.int
        |> required "hull" hullDecoder
        |> required "crew" D.int
        |> required "equipment" D.int
        |> required "weight" weightDecoder
        |> required "activated" D.bool
        |> required "weapons" (D.list weaponDecoder)
        |> required "upgrades" (D.list upgradeDecoder)
        |> required "notes" D.string
        |> required "cost" D.int
        |> required "id" D.int


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


vtypeDecoder : Decoder VehicleType
vtypeDecoder =
    D.string
        |> D.andThen (\str ->
            let
                vtype =
                    strToVT str
            in
                case vtype of
                    Just vt -> D.succeed vt
                    Nothing -> D.fail <| str ++ " is not a valid vehicle type"
        )


type alias GearTracker =
    { current : Int
    , max : Int
    }


gearDecoder : Decoder GearTracker
gearDecoder =
    decode GearTracker
        |> hardcoded 0
        |> required "max" D.int


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
    v.cost + (List.sum <| List.map .cost v.weapons) + (List.sum <| List.map .cost v.upgrades)


type WeightClass
    = Light
    | Middle
    | Heavy
    | Airborne


weightDecoder : Decoder WeightClass
weightDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Light" -> D.succeed Light
                "Middle" -> D.succeed Middle
                "Heavy" -> D.succeed Heavy
                "Ariborne" -> D.succeed Airborne
                _ -> D.fail <| str ++ " is not a valid weight."
        )


type alias HullHolder =
    { current : Int
    , max : Int
    }


hullDecoder : Decoder HullHolder
hullDecoder =
    decode HullHolder
        |> hardcoded 0
        |> required "max" D.int


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
        handling
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
    -100


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
