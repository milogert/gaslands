module Model.Upgrades exposing (Upgrade, allUpgradesList, armourPlating, extraCrewmember, nameToUpgrade, nitroBooster, tankTracks)

import Model.Weapons exposing (..)


type alias Upgrade =
    { name : String
    , slots : Int
    , specials : List Special
    , cost : Int
    , id : Int
    }


allUpgradesList : List Upgrade
allUpgradesList =
    [ nitroBooster
    , armourPlating
    , tankTracks
    , extraCrewmember
    ]


nameToUpgrade : String -> Maybe Upgrade
nameToUpgrade name =
    case name of
        "Nitro Booster" ->
            Just nitroBooster

        "Armour Plating" ->
            Just armourPlating

        "Tank Tracks" ->
            Just tankTracks

        "Extra Crewmember" ->
            Just extraCrewmember

        _ ->
            Nothing


nitroBooster : Upgrade
nitroBooster =
    Upgrade "Nitro Booster"
        0
        [ Ammo 1
        , SpecialRule "This vehicle ay declare that it is using this item at the start of an activation. This vehicle activates twice during this activation."
        , SpecialRule "During its first activation, this vehicle may only select the long straight template as its maneuver, does not make a skit check and must skip its attack step."
        , SpecialRule "After the first activation, this vehicle gains hazard tokens until it has 5 hazard tokens."
        , SpecialRule "During the second activation, this vehicle is free to choose a maneuver as normal, must make a skid check as normal, and may take its attack step as normal."
        , SpecialRule "After the second activation, this vehicle gains hazard toeksn until it has 5 hazard tokens."
        ]
        6
        -1


armourPlating : Upgrade
armourPlating =
    Upgrade "Armour Plating"
        1
        [ HullMod 2
        , SpecialRule "The vehicle has been loaded with additional plates and shielding, raising its hull value by 2."
        , SpecialRule "A single vehicle may be fitted with multiple Armour Plating upgrades for further +2 hull points each time."
        ]
        4
        -1


tankTracks : Upgrade
tankTracks =
    Upgrade "Tank Tracks"
        1
        [ GearMod -1
        , HandlingMod 1
        , SpecialRule "The vehicle with tank tracks has had its wheels replaced with caterpillar tracks. It increases its handling by 1 but reduces its max gear by 1. This vehicle may also ignore rough and treacherous surfaces."
        , SpecialRule "A vehicle may on purchase tank tracks once. Tanks, Helicopters, and Gyrocopers may not purchase tank tracks."
        ]
        4
        -1


extraCrewmember : Upgrade
extraCrewmember =
    Upgrade "Extra Crewmember" 0 [ CrewMod 1 ] 4 -1
