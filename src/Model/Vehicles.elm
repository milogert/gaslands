module Model.Vehicles exposing
    ( GearTracker
    , HullHolder
    , SkidResult(..)
    , Vehicle
    , VehicleEvent(..)
    , VehicleType(..)
    , WeightClass(..)
    , allVehicleTypes
    , allVehicles
    , fromVehicleType
    , fromVehicleWeight
    , slotsRemaining
    , slotsUsed
    , strToVT
    , vehicleCost
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrades exposing (..)
import Model.Weapons exposing (..)


type VehicleEvent
    = AddVehicle
    | DeleteVehicle Vehicle
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | NextGearPhase
    | UpdateActivated Vehicle Bool
    | UpdateGear Vehicle String
    | ShiftGear Vehicle Int Int Int
    | UpdateHazards Vehicle String
    | ShiftHazards Vehicle Int Int Int
    | UpdateHull Vehicle String
    | ShiftHull Vehicle Int Int Int
    | UpdateCrew Vehicle String
    | UpdateEquipment Vehicle String
    | UpdateNotes Vehicle String
    | SetPerkInVehicle Vehicle VehiclePerk Bool
    | GetStream Vehicle
    | TakePhoto Vehicle
    | SetPhotoUrlCallback String
    | DiscardPhoto Vehicle


type alias Vehicle =
    { name : String
    , photo : Maybe String
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
    , requiredSponsor : Maybe SponsorType
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


type alias HullHolder =
    { current : Int
    , max : Int
    }


slotsUsed : Vehicle -> Int
slotsUsed v =
    List.sum <| List.map .slots v.weapons ++ List.map .slots v.upgrades


slotsRemaining : Vehicle -> Int
slotsRemaining v =
    v.equipment - slotsUsed v


allVehicles : List Vehicle
allVehicles =
    [ bike
    , buggy
    , car
    , performanceCar
    , pickupTruck
    , monsterTruck
    , bus
    , warRig
    , tank
    , gyrocopter
    , helicopter
    ]


defaultVehicle : Vehicle
defaultVehicle =
    Vehicle
        ""
        Nothing
        Bike
        (GearTracker 0 0)
        0
        0
        []
        (HullHolder 0 0)
        0
        0
        Light
        False
        []
        []
        ""
        0
        0
        []
        []
        Nothing


bike : Vehicle
bike =
    { defaultVehicle
        | vtype = Bike
        , gear = GearTracker 1 6
        , handling = 5
        , hull = HullHolder 1 4
        , crew = 1
        , equipment = 1
        , weight = Light
        , cost = 5
        , specials =
            [ NamedSpecialRule "Full Throttle" "This vehicle considers the long straight maneuver template to be permitted in any gear. The long straight is not considered either hazardous or trivial in any gear."
            , NamedSpecialRule "Pivot" "At the start of this vehicle's activation, if this vehicle's current gar is 1, this vehicle may make a pivot about its centre to face any direction. This pivot cannot cause a collision, and cannot leave this vehicle touching an obstruction."
            ]
    }


buggy : Vehicle
buggy =
    { defaultVehicle
        | vtype = Buggy
        , gear = GearTracker 1 6
        , handling = 4
        , hull = HullHolder 1 6
        , crew = 2
        , equipment = 2
        , weight = Light
        , cost = 5
        , specials =
            [ NamedSpecialRule "Roll Cage" "When this vehicle suffers a flip, this vehicle may choose to ignore the 2 hits received from the flip."
            ]
    }


car : Vehicle
car =
    { defaultVehicle
        | vtype = Car
        , gear = GearTracker 1 5
        , handling = 3
        , hull = HullHolder 1 10
        , crew = 2
        , equipment = 2
        , weight = Middle
        , cost = 12
    }


performanceCar : Vehicle
performanceCar =
    { defaultVehicle
        | vtype = PerformanceCar
        , gear = GearTracker 1 6
        , handling = 4
        , hull = HullHolder 1 8
        , crew = 1
        , equipment = 2
        , weight = Middle
        , cost = 15
        , specials =
            [ NamedSpecialRule "Slip Away" "If this vehicle is targeted wtih a tailgate, T-bone or sideswipe smash attack, and this vehicle declares evade as its reaction, this vehicle may perform a free activation immediately after the active vehicle completes its activation."
            , SpecialRule "This free activation does not count as the vehicle's activation this gear phase."
            ]
    }


pickupTruck : Vehicle
pickupTruck =
    { defaultVehicle
        | vtype = PickupTruck
        , gear = GearTracker 1 4
        , handling = 2
        , hull = HullHolder 1 12
        , crew = 3
        , equipment = 3
        , weight = Middle
        , cost = 15
    }


monsterTruck : Vehicle
monsterTruck =
    { defaultVehicle
        | vtype = MonsterTruck
        , gear = GearTracker 1 4
        , handling = 3
        , hull = HullHolder 1 10
        , crew = 2
        , equipment = 2
        , weight = Heavy
        , cost = 25
        , specials =
            [ NamedSpecialRule "Big Tires" "This vehicle may ignore the penalty for being on a rough surface, and considers a treacherous surface to be a rough surface."
            , NamedSpecialRule "Crush Attack" "After resolving a collision with a Bike, Buggy, Car, Pickup Truck, Performance Car, Lightweight Obstacle or Middleweight Obstacle during movement step 1.7, this vehicle may ignore the obstruction for the remainder of its movement step, as it drives right over the top of it."
            ]
    }


bus : Vehicle
bus =
    { defaultVehicle
        | vtype = Bus
        , gear = GearTracker 1 3
        , handling = 2
        , hull = HullHolder 1 16
        , crew = 8
        , equipment = 3
        , weight = Heavy
        , cost = 30
    }


warRig : Vehicle
warRig =
    { defaultVehicle
        | vtype = WarRig
        , gear = GearTracker 1 4
        , handling = 2
        , hull = HullHolder 1 20
        , crew = 5
        , equipment = 5
        , weight = Heavy
        , cost = 40
        , specials = [ SpecialRule "See Page 52 of the core rulebook." ]
    }


tank : Vehicle
tank =
    { defaultVehicle
        | vtype = Tank
        , gear = GearTracker 1 3
        , handling = 4
        , hull = HullHolder 1 20
        , crew = 3
        , equipment = 4
        , weight = Heavy
        , cost = 40
        , specials =
            [ NamedSpecialRule "Pivot" "At the start of this vehicle's activation, if this vehicle's current gar is 1, this vehicle may make a pivot about its centre to face any direction. This pivot cannot cause a collision, and cannot leave this vehicle touching an obstruction."
            , NamedSpecialRule "Crush Attack" "After resolving a collision with a Bike, Buggy, Car, Pickup Truck, Performance Car, Lightweight Obstacle or Middleweight Obstacle during movement step 1.7, this vehicle may ignore the obstruction for the remainder of its movement step, as it drives right over the top of it."
            , NamedSpecialRule "All Terrain" "This vehicle may ignore the penalties for rough and treacherous surfaces."
            ]
        , requiredSponsor = Just Rutherford
    }


gyrocopter : Vehicle
gyrocopter =
    { defaultVehicle
        | vtype = Gyrocopter
        , gear = GearTracker 1 3
        , handling = 4
        , hull = HullHolder 1 4
        , crew = 1
        , equipment = 0
        , weight = Airborne
        , cost = 10
        , specials =
            [ NamedSpecialRule "Air Wolf" "At the start of this vehicle's activation, this vehicle may make a single pivot about its centre point, up to 90 degrees."
            , NamedSpecialRule "Airborne" "This vehicle ignores obstructions, dropped weapons and terrain at all times, except that this vehicle may target other vehicles in its attack step."
            , SpecialRule "Other vehicles ignore this vehicle at all times, except that other vehicles may target this vehicle during their attack steps. This vehicle cannot be involved in collisions."
            , NamedSpecialRule "Bombs Away" "When purchasing weapons, this vehicle may count dropped weapons as requiring 0 build slots."
            ]
    }


helicopter : Vehicle
helicopter =
    { defaultVehicle
        | vtype = Helicopter
        , gear = GearTracker 1 4
        , handling = 3
        , hull = HullHolder 1 8
        , crew = 2
        , equipment = 4
        , weight = Airborne
        , cost = 30
        , specials =
            [ NamedSpecialRule "Air Wolf" "At the start of this vehicle's activation, this vehicle may make a single pivot about its centre point, up to 90 degrees."
            , NamedSpecialRule "Airborne" "This vehicle ignores obstructions, dropped weapons and terrain at all times, except that this vehicle may target other vehicles in its attack step."
            , SpecialRule "Other vehicles ignore this vehicle at all times, except that other vehicles may target this vehicle during their attack steps. This vehicle cannot be involved in collisions."
            , NamedSpecialRule "Bombs Away" "When purchasing weapons, this vehicle may count dropped weapons as requiring 0 build slots."
            ]
        , requiredSponsor = Just Rutherford
    }



-- Vehicle definitions.


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
