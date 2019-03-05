module Model.Weapon.TimeExtended2 exposing (weapons)

import Model.Shared exposing (..)
import Model.Weapon.Model exposing (..)


weapons : List Weapon
weapons =
    [ submachineGuns
    , shotgun
    , rifle
    , steelNets
    , gasGrenades
    , bfg
    , combatLaser
    , gravGun
    , grabberArm
    , harpoon
    , homingMissile
    , hypnoRay
    , wreckingBall
    , wreckLobber
    , blunderbuss
    , rcCarBombs
    , sentryGun
    ]


submachineGuns : Weapon
submachineGuns =
    { defaultWeapon
        | name = "Submachine Guns"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , range = Medium
        , specials = [ Specialist ]
        , cost = 6
    }


shotgun : Weapon
shotgun =
    { defaultWeapon
        | name = "Shotgun"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , range = BurstSmall
        , specials = [ Specialist ]
        , cost = 3
    }


rifle : Weapon
rifle =
    { defaultWeapon
        | name = "Rifle"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , range = Double
        , specials = [ Specialist ]
        , cost = 2
    }


steelNets : Weapon
steelNets =
    { defaultWeapon
        | name = "Steel Nets"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , range = Medium
        , specials = [ Specialist, Entangle ]
        , cost = 1
    }


gasGrenades : Weapon
gasGrenades =
    { defaultWeapon
        | name = "Gas Grenades"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , range = Medium
        , specials =
            [ ammoInit 5
            , Blitz
            , NamedSpecialRule "Choking Gas" "TODO"
            ]
        , cost = 1
    }


bfg : Weapon
bfg =
    { defaultWeapon
        | name = "BFG"
        , wtype = Shooting
        , range = Double
        , specials =
            [ Ammo [ False ]
            , NamedSpecialRule "Ridonkulous Firepower" "When this weapon is fired, the vehicle is immediately moved a Short Straight backwards, is reduced to gear 1, and receives 3 hazard tokens. Front mounted only (Ed: Another Battlehammer special)."
            ]
        , cost = 1
        , slots = 2
        , expansion = TX 2
    }


combatLaser : Weapon
combatLaser =
    { defaultWeapon
        | name = "Combat Laser"
        , wtype = Shooting
        , range = SpecialRange "Double (Burst)"
        , specials =
            [ NamedSpecialRule "Laser" "Lasers are template weapons, but instead of the regular burst templates, they use the double range shooting stick as a burst template."
            ]
        , cost = 5
        , slots = 1
        , expansion = TX 2
    }


deathRay : Weapon
deathRay =
    { defaultWeapon
        | name = "Death Ray"
        , wtype = Shooting
        , range = Double
        , specials =
            [ ammoInit 1
            , NamedSpecialRule "Atomize" "If this weapon scores five or more un-cancelled hits on the target, instead of causing damage, the target car is immediately removed from play (although it counts as having been wrecked for the purposes of audience votes, scenario rules, etc.)."
            ]
        , cost = 3
        , slots = 1
        , expansion = TX 2
    }


gravGun : Weapon
gravGun =
    { defaultWeapon
        | name = "Grav Gun"
        , wtype = Shooting
        , range = Double
        , specials =
            [ ammoInit 1
            , Electrical
            , NamedSpecialRule "Gravity Manipulation" ""
            ]
        , cost = 2
        , slots = 1
        , expansion = TX 2
    }


grabberArm : Weapon
grabberArm =
    { defaultWeapon
        | name = "Grabber Arm"
        , wtype = Shooting
        , range = Short
        , specials =
            [ NamedSpecialRule "Toss" ""
            ]
        , cost = 6
        , slots = 1
        , expansion = TX 2
    }


harpoon : Weapon
harpoon =
    { defaultWeapon
        | name = "Harpoon"
        , wtype = Shooting
        , range = Double
        , specials =
            [ NamedSpecialRule "Harpoon" ""
            ]
        , cost = 2
        , slots = 1
        , expansion = TX 2
    }


homingMissile : Weapon
homingMissile =
    { defaultWeapon
        | name = "Homing Missile"
        , wtype = Shooting
        , range = SpecialRange "Heat Seeking"
        , specials =
            [ ammoInit 3
            , Blast
            , HighlyExplosive
            , NamedSpecialRule "Heat-seeking" ""
            ]
        , cost = 8
        , slots = 2
        , expansion = TX 2
    }


hypnoRay : Weapon
hypnoRay =
    { defaultWeapon
        | name = "Hypno Ray"
        , wtype = Shooting
        , range = Double
        , specials =
            [ ammoInit 1
            , Blast
            , NamedSpecialRule "Mind Control" ""
            ]
        , cost = 2
        , slots = 1
        , expansion = TX 2
    }


wreckingBall : Weapon
wreckingBall =
    { defaultWeapon
        | name = "Wrecking Ball"
        , wtype = Shooting
        , range = SpecialRange "Collision"
        , specials =
            [ NamedSpecialRule "Steel Ball" ""
            ]
        , cost = 4
        , slots = 1
        , expansion = TX 2
    }


wreckLobber : Weapon
wreckLobber =
    { defaultWeapon
        | name = "Wreck Lobber"
        , wtype = Shooting
        , range = SpecialRange "Dropped/Double"
        , specials =
            [ ammoInit 3
            , NamedSpecialRule "Trebuchet" ""
            , NamedSpecialRule "Low-loader" ""
            , NamedSpecialRule "Dumper" ""
            ]
        , cost = 4
        , slots = 4
        , expansion = TX 2
    }


blunderbuss : Weapon
blunderbuss =
    { defaultWeapon
        | name = "Blunderbuss"
        , wtype = Shooting
        , range = Double
        , specials =
            [ NamedSpecialRule "Scrapshot" ""
            ]
        , cost = 2
        , slots = 1
        , expansion = TX 2
    }


rcCarBombs : Weapon
rcCarBombs =
    { defaultWeapon
        | name = "RC Car Bombs"
        , wtype = Dropped
        , range = Short
        , specials =
            [ ammoInit 3
            , NamedSpecialRule "Remote-Controlled Car" ""
            ]
        , cost = 6
        , slots = 0
        , expansion = TX 2
    }


sentryGun : Weapon
sentryGun =
    { defaultWeapon
        | name = "Sentry Gun"
        , wtype = Dropped
        , range = SpecialRange "Dropped -> Small Burst"
        , specials =
            [ ammoInit 2
            , NamedSpecialRule "Sentry Gun" ""
            ]
        , cost = 2
        , slots = 0
        , expansion = TX 2
    }
