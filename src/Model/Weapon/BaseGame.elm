module Model.Weapon.BaseGame exposing (handgun, weapons)

import Model.Shared exposing (..)
import Model.Sponsors exposing (stringToSponsor)
import Model.Weapon exposing (..)


weapons : List Weapon
weapons =
    -- Basic weapons.
    [ handgun
    , machineGun
    , heavyMachineGun
    , miniGun

    -- Advance weapons.
    , arcLightningProjector
    , bazooka
    , bfg
    , combatLaser
    , deathRay
    , flamethrower
    , grabberArm
    , gravGun
    , harpoon
    , kineticSuperBooster
    , magneticJammer
    , mortar
    , oneTwentyFiveMMCannon
    , rockets
    , thumper
    , wallOfAmplifiers
    , wreckLobber
    , wreckingBall

    -- Crew fired weapons.
    , blunderbuss
    , gasGrenades
    , grenades
    , magnum
    , molotovCocktails
    , shotgun
    , steelNets
    , submachineGuns

    -- Dropped weapons.
    , caltropDropper
    , glueDropper
    , mineDropper
    , napalmDropper
    , oilSlickDropper
    , rcCarBombs
    , sentryGun
    , smokeDropper
    ]



-- Basic weapons.


handgun : Weapon
handgun =
    { defaultWeapon
        | name = "Handgun"
        , range = Medium
        , attack = Just (Dice 1 6)
        , mountPoint = Just CrewFired
    }


machineGun : Weapon
machineGun =
    { defaultWeapon
        | name = "Machine Gun"
        , range = Double
        , attack = Just (Dice 2 6)
        , slots = 1
        , cost = 2
    }


heavyMachineGun : Weapon
heavyMachineGun =
    { defaultWeapon
        | name = "Heavy Machine Gun"
        , range = Double
        , attack = Just (Dice 3 6)
        , slots = 1
        , cost = 3
    }


miniGun : Weapon
miniGun =
    { defaultWeapon
        | name = "Mini-Gun"
        , range = Double
        , attack = Just (Dice 4 6)
        , slots = 1
        , cost = 5
    }



-- Advance weapons.


oneTwentyFiveMMCannon : Weapon
oneTwentyFiveMMCannon =
    { defaultWeapon
        | name = "125mm Cannon"
        , range = Double
        , attack = Just (Dice 8 6)
        , slots = 3
        , cost = 6
        , specials =
            [ Ammo [ False, False, False ]
            , Blast
            , SpecialRule "A tank gun is a ridiculous weapon for a civilian vehicle to carry. When fired, the active vehicle immediately gains 2 Hazard Tokens if it is not a Tank."
            ]
    }


arcLightningProjector : Weapon
arcLightningProjector =
    { defaultWeapon
        | name = "Arc Lightning Projector"
        , range = Double
        , attack = Just (Dice 6 6)
        , slots = 2
        , cost = 6
        , specials =
            [ Ammo [ False ]
            , Electrical
            , SpecialRule "The Arc Lightning Projector is a dangerous electrical weapon that can arc electricity across multiple conductive targets. After damaging a target, this vehicle must immediately attack another target within Short range and a 360-degree Arc of Fire of the current target (including this vehicle). This chain-reaction continues until the weapon fails to damage a target, or there are nor further viable targets. This vehicle can target friendly vehicles with the Arc Lightning Projector. This vehicle cannot target the same vehicle twice in a single attack step with the Arc Lightning Projetor."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


bazooka : Weapon
bazooka =
    { defaultWeapon
        | name = "Bazooka"
        , range = Double
        , attack = Just (Dice 3 6)
        , slots = 2
        , cost = 4
        , specials =
            [ Ammo [ False, False, False ]
            , Blast
            ]
    }


bfg : Weapon
bfg =
    { defaultWeapon
        | name = "BFG"
        , range = Double
        , attack = Just (Dice 10 6)
        , slots = 3
        , cost = 1
        , specials =
            [ Ammo [ False ]
            , SpecialRule "When this weapon is fired, the vehicle makes an immediately forced move medium straight backwards, is reduced to Gear 1, and receives 3 Hazard Tokens. Front mounted only (Ed: Another Battlehammer special)."
            ]
    }


combatLaser : Weapon
combatLaser =
    { defaultWeapon
        | name = "Combat Laser"
        , range = Double
        , attack = Just (Dice 3 6)
        , slots = 1
        , cost = 5
        , specials = [ Splash ]
    }


deathRay : Weapon
deathRay =
    { defaultWeapon
        | name = "Death Ray"
        , range = Double
        , attack = Just (Dice 3 6)
        , slots = 1
        , cost = 3
        , specials =
            [ ammoInit 1
            , Electrical
            , SpecialRule "If this weapon scores five or more un-cancelled hits on the target, instead of causing damage, the target car is immediately removed from play (although it counts as having been Wrecked for the purposes of Audience Votes, scenario rules, etc.)."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


flamethrower : Weapon
flamethrower =
    { defaultWeapon
        | name = "Flamethrower"
        , range = TemplateLarge
        , attack = Just (Dice 6 6)
        , slots = 2
        , cost = 4
        , specials = [ ammoInit 3, Splash, Fire, Indirect ]
    }


grabberArm : Weapon
grabberArm =
    { defaultWeapon
        | name = "Grabber Arm"
        , range = Short
        , attack = Just (Dice 3 6)
        , slots = 1
        , cost = 6
        , specials =
            [ SpecialRule "If this vehicle attacks a target vehicle of the same weight class or lighter with the Grabber Arm and scors one or more un-cancelled hits, the controller of the active vehicle may place the target vehicle anywhere within Short range of the target vehicle's original position. The target vehicle may be pivoted to face any direction. This movement causes a Collision Window." ]
    }


gravGun : Weapon
gravGun =
    { defaultWeapon
        | name = "Grav Gun"
        , range = Double
        , attack = Just (Dice 6 6) -- Parens in rulebook?
        , slots = 1
        , cost = 2
        , specials =
            [ ammoInit 1
            , Electrical
            , SpecialRule "If this weapon scores one or more un-cancelled hits on the target, instead of causing damage the attacking vehicle's controller must choose one of the following: until the end of the target's next activation the target counts as one weight class heavier or until the end of the target's next activation the target counts as one weight class lighter."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


harpoon : Weapon
harpoon =
    { defaultWeapon
        | name = "Harpoon"
        , range = Double
        , attack = Just (Dice 5 6)
        , slots = 1
        , cost = 2
        , specials =
            [ SpecialRule "This weapon's hits do not cause damage. Instead, the first un-cancelled hit on the target spins the target vehicle on the spot to either face directly away from or directly towards the attacking vehicle, whichever requires the smalled degree of rotation, as the harpoon catches and the chain goes taut. This triggers a Collision Window."
            , SpecialRule "The second and subsequent un-cancelled hits on the target then each cause the target to make a forced Short Straight move towards the attacker, as the harpoon reels the target in."
            , SpecialRule "If the target is a heavier weight class than the attacker, it is the attacking vehicle that is spun and moved towards the target vehicle instead."
            ]
    }


kineticSuperBooster : Weapon
kineticSuperBooster =
    { defaultWeapon
        | name = "Kinetic Super Booster"
        , range = Double
        , attack = Just (Dice 1 6)
        , slots = 2
        , cost = 6
        , specials =
            [ ammoInit 1
            , Electrical
            , SpecialRule "The Kinetic Super Booster is a bizarre electrical weapon that transfers a jolt of kinetic energy to the target. The target of a Super Booster attack suffers no damage, but instread immediately increases its current Gear by one for every successful hit, without gaining hazard tokens. The Super Booster may not increase a vehicle's current Gear beyond its max Gear."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


magneticJammer : Weapon
magneticJammer =
    { defaultWeapon
        | name = "Magnetic Jammer"
        , range = Double
        , slots = 0
        , cost = 2
        , specials =
            [ Electrical
            , SpecialRule "The target vehicle may not discard ammo tokens during its next activation."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


mortar : Weapon
mortar =
    { defaultWeapon
        | name = "Mortar"
        , range = Double
        , attack = Just (Dice 4 6)
        , slots = 1
        , cost = 4
        , specials = [ ammoInit 3, Indirect, SpecialRule "When making a shooting attack with the Mortar, the vehicle may ignore terrain and cover during the attack." ]
    }


rockets : Weapon
rockets =
    { defaultWeapon
        | name = "Rockets"
        , range = Double
        , attack = Just (Dice 6 6)
        , slots = 2
        , cost = 5
        , specials = [ ammoInit 3 ]
    }


thumper : Weapon
thumper =
    { defaultWeapon
        | name = "Thumper"
        , range = Medium
        , slots = 3
        , cost = 4
        , specials =
            [ ammoInit 1
            , Electrical
            , Indirect
            , FullFireArc
            , SpecialRule "This weapon does not need to declare a facing when purchased."
            , SpecialRule "The Thumper is a powerful sonic device that emits a shock wave that hurls nearby vehicles into the air. When this vehicle declares an attack with the Thumper, every other vehicle (friend or foe) within Medium range of this vehicle in a 360-degree Arc of Fire immeditaly makes a Flip check, in which they count their current Gear as 2 higher, up to a maximum of 6."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


wallOfAmplifiers : Weapon
wallOfAmplifiers =
    { defaultWeapon
        | name = "Wall of Amplifiers"
        , range = Medium
        , slots = 4
        , cost = 4
        , specials =
            [ FullFireArc
            , SpecialRule "This weapon does not require a target. When fired, this weapon automatically cuases on hit to every vehicle within Medium range and within a 36-degree Arc of Fire. These hits do not cause damage and may be Evaded. For each un-cancelled hit on a vehicle, choose one: either discard 1 Hazard Token from the vehicle or add 1 Hazard Token to the vehicle."
            ]
    }


wreckLobber : Weapon
wreckLobber =
    { defaultWeapon
        | name = "Wreck Lobber"
        , range = SpecialRange "Double/Dropped"
        , slots = 4
        , cost = 4
        , specials =
            [ ammoInit 3
            , SpecialRule "It was inevitable that someone would invent a gun that shoots cars instead of bullets."
            , NamedSpecialRule "Trebuchet" "The Wreck Lobber does not require a target. When it is fired, place a marker the size of a penny within Double range of the Wreck Lobber's fire arc. Roll a Skid Die."
            , SpecialRule "On a Shift result: place the wreck of a Car touching the marker and trigger a Collision Window."
            , SpecialRule "On a Spin or Slide result: the player to the left of the active player must place a wreck anywhere within Short range of the marker and trigger a Collision Window."
            , SpecialRule "On a Hazard Result: the player to the left of the active player must place the wreck touching the active vehicle and trigger a Collision Window."
            , NamedSpecialRule "Low-Loader" "If this vehicle collides with a wreck, it may gain 1 Ammo Token for the Wreck Lobber."
            , NamedSpecialRule "Dumper" "This vehicle may fire the Wreck Lobber as a rear-mounted dropped weapon instead of using the Trebuchet rules above. In this case, the wreck of a car is placed touching the rear of the active vehicle, and no Collision Window is triggered."
            ]
    }


wreckingBall : Weapon
wreckingBall =
    { defaultWeapon
        | name = "Wrecking Ball"
        , range = SpecialRange "Collision"
        , slots = 1
        , cost = 4
        , specials =
            [ SpecialRule "This weapon does not require a target. When fired, this vehicle must immediately engage in a T-Bone Collision with every vehicle and Destructible obstacle within Short range of it, in a 360-degree Arc of Fire, in any order chosedn by this vehicle's controller."
            , SpecialRule "During these Collisions, all vehicles involved count as having no weapons or perks except this one and all other vehicles must declare an Evade reaction. During each of these Collisions this vehicle gains 2 Smash Attack dice. this vehicle does not gain Hazard Tokens during these Collisions. Collisions triggered by the Wrecking Ball do not benefit from effects from upgrades, such as Rams or Exploding Rams."
            ]
    }



-- Crew fired weapons.


blunderbuss : Weapon
blunderbuss =
    { defaultWeapon
        | name = "Blunderbuss"
        , range = BurstRange Small
        , cost = 2
        , specials = [ Splash ]
        , mountPoint = Just CrewFired
    }


gasGrenades : Weapon
gasGrenades =
    { defaultWeapon
        | name = "Gas Grenades"
        , range = Medium
        , attack = Just (Dice 1 6) -- TODO parens
        , cost = 1
        , specials =
            [ ammoInit 5
            , Indirect
            , Blitz
            , SpecialRule "If this weapons scores one or more un-cancelled hitson the target, instead of causing damage, reduce the target's Crew Value by 1 for each un-cancelled hit, to a minimum of 0, until the end of the Gear Phase."
            ]
        , mountPoint = Just CrewFired
    }


grenades : Weapon
grenades =
    { defaultWeapon
        | name = "Grenades"
        , range = Medium
        , attack = Just (Dice 1 6)
        , cost = 1
        , specials = [ ammoInit 5, Blast, Indirect, Blitz ]
        , mountPoint = Just CrewFired
    }


magnum : Weapon
magnum =
    { defaultWeapon
        | name = "Magnum"
        , range = Double
        , attack = Just (Dice 1 6)
        , cost = 3
        , specials = [ Blast ]
        , mountPoint = Just CrewFired
    }


molotovCocktails : Weapon
molotovCocktails =
    { defaultWeapon
        | name = "Molotov Cocktails"
        , range = Medium
        , attack = Just (Dice 1 6)
        , cost = 1
        , specials = [ ammoInit 5, Fire, Indirect, Blitz ]
        , mountPoint = Just CrewFired
    }


shotgun : Weapon
shotgun =
    { defaultWeapon
        | name = "Shotgun"
        , range = Long
        , attack = Nothing --TODO
        , cost = 4
        , specials =
            [ SpecialRule "When attacking with this weapon, roll 3D6 attack dice if the target is within Short range, 2D6 attack dice if the target is within Medium range, and 1D6 attack dice if the target is within Long range."
            ]
        , mountPoint = Just CrewFired
    }


steelNets : Weapon
steelNets =
    { defaultWeapon
        | name = "Steel Nets"
        , range = Medium
        , attack = Just (Dice 3 6) -- TODO
        , cost = 2
        , specials =
            [ Blast
            , SpecialRule "This weapon's hits do not cause damage. Hits will add Hazard Tokens as a result of the Blast special rule as normal."
            ]
        , mountPoint = Just CrewFired
    }


submachineGuns : Weapon
submachineGuns =
    { defaultWeapon
        | name = "Submachine Guns"
        , range = Medium
        , attack = Just (Dice 3 6)
        , cost = 5
        , mountPoint = Just CrewFired
    }



-- Dropped weapons.


caltropDropper : Weapon
caltropDropper =
    { defaultWeapon
        | name = "Caltrop Dropper"
        , range = Dropped
        , attack = Just (Dice 2 6)
        , slots = 1
        , cost = 1
        , specials =
            [ ammoInit 3
            , BurstSpecial Small
            , SpecialRule "If any part of a vehicle's maneuver template or final position overlaps the caltrops burst template, that vehicle immediately loses 2 hull points and then that caltrops template is removed."
            ]
    }


glueDropper : Weapon
glueDropper =
    { defaultWeapon
        | name = "Glue Dropper"
        , range = Dropped
        , slots = 1
        , cost = 1
        , specials =
            [ ammoInit 1
            , BurstSpecial Large
            , SpecialRule "Any vehicle that either starts its activation touching the template, or whose maneuver template or final position overlaps the dropped weapon template during its activation, reduces its current gear by 2 at the end of their activation."
            ]
    }


mineDropper : Weapon
mineDropper =
    { defaultWeapon
        | name = "Mine Dropper"
        , range = Dropped
        , attack = Just (Dice 1 6)
        , slots = 1
        , cost = 1
        , specials =
            [ ammoInit 1
            , BurstSpecial Small
            , Blast
            , SpecialRule "The first vehicle affected by this weapon is attacked with a 4D6 attack with Blast, then remove the Mine's template from play."
            ]
    }


napalmDropper : Weapon
napalmDropper =
    { defaultWeapon
        | name = "Napalm Dropper"
        , range = Dropped
        , attack = Just (Dice 4 6)
        , slots = 1
        , cost = 1
        , specials =
            [ ammoInit 3
            , BurstSpecial Small
            , Fire
            , SpecialRule "The first vehicle affected by this weapon is attacked with a 4D6 attack with Fire, then remove the Napalm template from play."
            ]
    }


oilSlickDropper : Weapon
oilSlickDropper =
    { defaultWeapon
        | name = "Oil Slick Dropper"
        , range = Dropped
        , cost = 2
        , specials =
            [ ammoInit 3
            , BurstSpecial Large
            , SpecialRule "The dropped weapon template for the Oil Slick Dropper counts as a treacherous surface, (see Terrain, page 86)."
            ]
    }


rcCarBombs : Weapon
rcCarBombs =
    { defaultWeapon
        | name = "RC Car Bombs"
        , range = Dropped
        , attack = Just (Dice 4 6)
        , cost = 3
        , specials =
            [ ammoInit 3
            , BurstSpecial Large
            , SpecialRule "Bombs are taped to remote-controleld cars, which are dropped from a vehicle and then piloted to impact."
            , SpecialRule "When attack with this dropped weapon, placea RC Car (use a tiny car miniature, no larger than 20mm square) so that it is within Short range of the attacking vehicle, and facing in any diretion. This placement triggers a Collision Window."
            , SpecialRule "The RC Car counts as a lightweight vehicle in current Gear 3 with 1 Hull Point, 1 Crew, and 0 Handling. This tiny car can make shooting attacks but cannot change Gear. Although controlled by the player that dropped it, the RC Car does not count as part of the player's team, and so cannot be used for the purposes of scenario rules, Audience Votes, or perks."
            , SpecialRule "The RC Car is involved in a Collision, it suffers one damage before the Collision is resolved. When the RC Car would be Wrecked it instead explodes. When the RC Car explodes, it rolls 4D6 attack dice, as if it were a middleweight vehicle."
            , SpecialRule "If the RC Car wipes out, it suffers one damage before the Wipeout is resolved."
            ]
    }


sentryGun : Weapon
sentryGun =
    { defaultWeapon
        | name = "Sentry Gun"
        , range = Dropped
        , cost = 3
        , specials =
            [ ammoInit 2
            , BurstSpecial Large
            , SpecialRule "When attacking with this dropped weapon, palce a Sentry Gun so that it is within Short range of the attacking vehicle."
            , SpecialRule "The Sentry Gun remains in play as a lightweight destructible obstacle. They may be targeted with shooting attacks and have 2 Hull Points."
            , SpecialRule "This Sentry Gun automatically makes a 2D6 shooting attack agains any vehicle taht ends their Movement Step within Medium range of the Sentry Gun in a 360-degree Arc of Fire. the target may Evade as normal. this Sentry Gun will never target vehicles from the team of the vehicle that dropped it."
            , SpecialRule "Although controlled by the player that dropped it, the Sentry Gun does not count as part of the player's team, and so cannot be used for the purposes of scenario rules, Audience Votes, or perks."
            ]
    }


smokeDropper : Weapon
smokeDropper =
    { defaultWeapon
        | name = "Smoke Dropper"
        , range = Dropped
        , cost = 1
        , specials =
            [ ammoInit 3
            , BurstSpecial Large
            , SpecialRule "This dropped weapon template counts as an obstruction for the purposes of determining Cover."
            , SpecialRule "Whilst a vehicle is in contact with this dropped weapon template, that vehicle counts as distracted."
            , SpecialRule "If any part of a vehicle's movement template or Final Position toughes this dropped weapon template, the vehicle gains 1 Hazard Token at the end of its Movement Step."
            ]
    }
