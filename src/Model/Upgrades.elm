module Model.Upgrades exposing (Upgrade, allUpgradesList, armourPlating, defaultUpgrade, extraCrewmember, nameToUpgrade, nitroBooster, tankTracks, turretMounting)

import Model.Weapons exposing (..)


type alias Upgrade =
    { name : String
    , slots : Int
    , specials : List Special
    , cost : Int
    }


allUpgradesList : List Upgrade
allUpgradesList =
    [ turretMounting
    , nitroBooster
    , armourPlating
    , tankTracks
    , extraCrewmember
    ]


nameToUpgrade : String -> Upgrade
nameToUpgrade name =
    case name of
        "Turret Mounting For Weapons" ->
            turretMounting

        "Nitro Booster" ->
            nitroBooster

        "Armour Plating" ->
            armourPlating

        "Tank Tracks" ->
            tankTracks

        "Extra Crewmember" ->
            extraCrewmember

        _ ->
            defaultUpgrade


defaultUpgrade : Upgrade
defaultUpgrade =
    Upgrade "" 0 [] 0


turretMounting : Upgrade
turretMounting =
    Upgrade "Turret Mounting For Weapons" 0 [ SpecialRule "Weapon gains 360 arc of fire." ] 3


nitroBooster : Upgrade
nitroBooster =
    Upgrade "Nitro Booster" 0 [ Ammo 1, SpecialRule "TBD" ] 6


armourPlating : Upgrade
armourPlating =
    Upgrade "Armour Plating" 1 [ HullMod 2 ] 4


tankTracks : Upgrade
tankTracks =
    Upgrade "Tank Tracks" 1 [ GearMod -1, HandlingMod 1, SpecialRule "TBD" ] 4


extraCrewmember : Upgrade
extraCrewmember =
    Upgrade "Extra Crewmember" 0 [ CrewMod 1 ] 4
