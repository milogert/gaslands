module Model.Upgrade.BaseGame exposing (weapons)

import Model.Shared exposing (..)
import Model.Upgrade.Model exposing (..)


weapons : List Upgrade
weapons =
    [ nitroBooster
    , armourPlating
    , tankTracks
    , extraCrewmember
    ]


nitroBooster : Upgrade
nitroBooster =
    { defaultUpgrade
        | name = "Nitro Booster"
        , slots = 0
        , specials =
            [ Ammo [ False ]
            , SpecialRule "This vehicle may declare that it is using this item at the start of an activation. This vehicle activates twice during this activation."
            , SpecialRule "During its first activation, this vehicle may only select the long straight template as its maneuver, does not make a skit check and must skip its attack step."
            , SpecialRule "After the first activation, this vehicle gains hazard tokens until it has 5 hazard tokens."
            , SpecialRule "During the second activation, this vehicle is free to choose a maneuver as normal, must make a skid check as normal, and may take its attack step as normal."
            , SpecialRule "After the second activation, this vehicle gains hazard toeksn until it has 5 hazard tokens."
            ]
        , cost = 6
    }


armourPlating : Upgrade
armourPlating =
    { defaultUpgrade
        | name = "Armour Plating"
        , slots = 1
        , specials =
            [ HullMod 2
            , SpecialRule "The vehicle has been loaded with additional plates and shielding, raising its hull value by 2."
            , SpecialRule "A single vehicle may be fitted with multiple Armour Plating upgrades for further +2 hull points each time."
            ]
        , cost = 4
    }


tankTracks : Upgrade
tankTracks =
    { defaultUpgrade
        | name = "Tank Tracks"
        , slots = 1
        , specials =
            [ GearMod -1
            , HandlingMod 1
            , SpecialRule "The vehicle with tank tracks has had its wheels replaced with caterpillar tracks. It increases its handling by 1 but reduces its max gear by 1. This vehicle may also ignore rough and treacherous surfaces."
            , SpecialRule "A vehicle may on purchase tank tracks once. Tanks, Helicopters, and Gyrocopers may not purchase tank tracks."
            ]
        , cost = 4
    }


extraCrewmember : Upgrade
extraCrewmember =
    { defaultUpgrade
        | name = "Extra Crewmember"
        , slots = 0
        , specials = [ CrewMod 1 ]
        , cost = 4
    }
