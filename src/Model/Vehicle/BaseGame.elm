module Model.Vehicle.BaseGame exposing (vehicles)

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Vehicle exposing (..)


vehicles : List Vehicle
vehicles =
    -- Basic vehicles.
    [ List.map (setCategory Basic)
        [ buggy
        , car
        , performanceCar
        , truck
        , heavyTruck
        , bus
        ]

    -- Advanced vehicles.
    , List.map (setCategory Advanced)
        [ dragRacer
        , bike
        , bikeWithSidecar
        , iceCreamTruck
        , gyrocopter
        , ambulance
        , monsterTruck
        , helicopter
        , tank
        , warRig
        ]
    ]
        |> List.concat



-- Basic vehicles.


buggy : Vehicle
buggy =
    { defaultVehicle
        | type_ = "Buggy"
        , gear = GearTracker 1 6
        , handling = 4
        , hull = HullHolder 0 6
        , crew = 2
        , equipment = 2
        , weight = Light
        , cost = 6
        , specials =
            [ NamedSpecialRule "Roll Cage" "When this vehicle suffers a flip, this vehicle may choose to ignore the 2 hits received from the flip."
            ]
    }


car : Vehicle
car =
    { defaultVehicle
        | type_ = "Car"
        , gear = GearTracker 1 5
        , handling = 3
        , hull = HullHolder 0 10
        , crew = 2
        , equipment = 2
        , weight = Middle
        , cost = 12
    }


performanceCar : Vehicle
performanceCar =
    { defaultVehicle
        | type_ = "Performance Car"
        , gear = GearTracker 1 6
        , handling = 4
        , hull = HullHolder 0 8
        , crew = 1
        , equipment = 2
        , weight = Middle
        , cost = 15
        , specials =
            [ NamedSpecialRule "Slip Away" "If this vehicle is targeted wtih a Tailgate or T-bone Smash Attack, and this vehicle declares Evade as its reaction, this vehicle may perform a free activation immediately after the active vehicle completes its activation. This free activation does not count as the vehicle's activation this gear phase."
            ]
    }


truck : Vehicle
truck =
    { defaultVehicle
        | type_ = "Truck"
        , gear = GearTracker 1 4
        , handling = 2
        , hull = HullHolder 0 12
        , crew = 3
        , equipment = 3
        , weight = Middle
        , cost = 15
    }


heavyTruck : Vehicle
heavyTruck =
    { defaultVehicle
        | type_ = "Heavy Truck"
        , gear = GearTracker 1 3
        , handling = 2
        , hull = HullHolder 0 14
        , crew = 4
        , equipment = 5
        , weight = Heavy
        , cost = 25
    }


bus : Vehicle
bus =
    { defaultVehicle
        | type_ = "Bus"
        , gear = GearTracker 1 3
        , handling = 2
        , hull = HullHolder 0 16
        , crew = 8
        , equipment = 3
        , weight = Heavy
        , cost = 30
    }



-- Advanced vehicles.


dragRacer : Vehicle
dragRacer =
    { defaultVehicle
        | type_ = "Drag Racer"
        , weight = Light
        , hull = HullHolder 0 4
        , handling = 4
        , gear = GearTracker 1 6
        , crew = 1
        , equipment = 2
        , specials =
            [ NamedSpecialRule "Jet Engine" "A vehicle with a jet engine counts as having a Nitro Booster with infinite ammo tokens. This means this vehicle automatically Explodes when it is Wrecked. A vehicle with jet engine must use Nitro Booster every time it activates." ]
        , cost = 5
    }


bike : Vehicle
bike =
    { defaultVehicle
        | type_ = "Bike"
        , weight = Light
        , hull = HullHolder 0 4
        , handling = 5
        , gear = GearTracker 1 6
        , crew = 1
        , equipment = 1
        , specials =
            [ NamedSpecialRule "Full Throttle" "This vehicle considers the long straight maneuver template to be permitted in any gear. The long straight is not considered either hazardous or trivial in any gear."
            , pivot
            ]
        , cost = 5
    }


bikeWithSidecar : Vehicle
bikeWithSidecar =
    { bike
        | type_ = "Bike with Sidecar"
        , crew = 2
        , cost = 8
    }


iceCreamTruck : Vehicle
iceCreamTruck =
    { defaultVehicle
        | type_ = "Ice Cream Truck"
        , weight = Middle
        , hull = HullHolder 0 10
        , handling = 2
        , gear = GearTracker 1 4
        , crew = 2
        , equipment = 2
        , specials = [ NamedSpecialRule "Infuriating Jingle" "Vehicles that target this vehicle with a Smash Attack during a Collision gain no Hazard Tokens during step 6 of the Collision resolution." ]
        , cost = 8
    }


gyrocopter : Vehicle
gyrocopter =
    { defaultVehicle
        | type_ = "Gyrocopter"
        , weight = Heavy
        , hull = HullHolder 0 4
        , handling = 4
        , gear = GearTracker 1 3
        , crew = 1
        , equipment = 0
        , specials = flyingSpecials
        , cost = 10
    }


ambulance : Vehicle
ambulance =
    { defaultVehicle
        | type_ = "Ambulance"
        , weight = Middle
        , hull = HullHolder 0 12
        , handling = 2
        , gear = GearTracker 1 5
        , crew = 3
        , equipment = 3
        , specials =
            [ NamedSpecialRule "Uppers" "If this vehicle is involved in a Collision in which both vehicles declare an Evade, both vehicles must declare a single change Gear up immediately after the Collision is resolved (gaining a Hazard Token as normal). If either vehicle is already at its max Gear, the change of Gear does not affect that vehicle's current Gar, but that vehicles does gain a Hazard Token."
            , NamedSpecialRule "Downers" "When this vehicle is involved in a Collision during its activation in which it delcares a Smash Attack, the target vehicle does not gain any Hazard Tokens from the Colision and instead discards 2 Hazard Tokens. Then reduce the target vehicle's Crew Valuby 1 until the end of the Gear Phase."
            ]
        , cost = 20
    }


monsterTruck : Vehicle
monsterTruck =
    { defaultVehicle
        | type_ = "Monster Truck"
        , weight = Heavy
        , hull = HullHolder 0 10
        , handling = 3
        , gear = GearTracker 1 4
        , crew = 2
        , equipment = 2
        , specials =
            [ allTerrain
            , upAndOver
            ]
        , cost = 25
    }


helicopter : Vehicle
helicopter =
    { defaultVehicle
        | type_ = "Helicopter"
        , weight = Heavy
        , hull = HullHolder 0 8
        , handling = 3
        , gear = GearTracker 1 4
        , crew = 2
        , equipment = 4
        , specials = flyingSpecials
        , requiredSponsor = stringToSponsor "Rutherford"
        , cost = 30
    }


tank : Vehicle
tank =
    { defaultVehicle
        | type_ = "Tank"
        , gear = GearTracker 1 3
        , handling = 4
        , hull = HullHolder 0 20
        , crew = 3
        , equipment = 4
        , weight = Heavy
        , cost = 40
        , specials =
            [ allTerrain
            , pivot
            , NamedSpecialRule "Turret" "This vehicle may count one weapon as a turren-mounted weapon without paying for the upgrade."
            , upAndOver
            ]
        , requiredSponsor = stringToSponsor "Rutherford"
    }


warRig : Vehicle
warRig =
    { defaultVehicle
        | type_ = "WarRig"
        , gear = GearTracker 1 4
        , handling = 2
        , hull = HullHolder 0 20
        , crew = 5
        , equipment = 5
        , weight = Heavy
        , cost = 40
        , specials = [ SpecialRule "See War Rig rules." ]
    }


flyingSpecials : List Special
flyingSpecials =
    [ NamedSpecialRule "Airborne" "This vehicle ignores obstructions, dropped weapons and terrain at all times, except that this vehicle may target other vehicles in its attack step."
    , SpecialRule "Other vehicles ignore this vehicle at all times, except that other vehicles may target this vehicle during their attack steps. This vehicle cannot be involved in collisions."
    , NamedSpecialRule "Air Wolf" "At the start of this vehicle's activation, this vehicle may make a single pivot about its centre point, up to 90 degrees."
    , NamedSpecialRule "Bombs Away" "When purchasing weapons, this vehicle may count dropped weapons as requiring 0 build slots."
    ]


pivot : Special
pivot =
    NamedSpecialRule "Pivot" "At the start of this vehicle's activation, if this vehicle's current gar is 1, this vehicle may make a pivot about its centre to face any direction. This pivot cannot cause a collision, and cannot leave this vehicle touching an obstruction."


allTerrain : Special
allTerrain =
    NamedSpecialRule "All Terrain" "This vehicle may ignore the penalties for rough and treacherous surfaces."


upAndOver : Special
upAndOver =
    NamedSpecialRule "Up and Over" "During this vehicle's Movement Step, after resolving a Collision with an obstruction of a lower weight class, this vehicle may delcare that it is going \"Up and Over\". If ti does, it may ignore the obstruction for the remainder of its Movement STep, as it drives right over the top of it. This vehicle cannot use htis ability to ignore another vehicle with the \"Up and Over\" special rule."
