module Model.Upgrade.Data exposing (upgrades)

import Model.Shared exposing (..)
import Model.Sponsors exposing (stringToSponsor)
import Model.Upgrade exposing (..)
import Model.Vehicle exposing (WeightClass(..))


upgrades : List Upgrade
upgrades =
    [ armourPlating
    , experimentalNuclearEngine
    , experimentalTeleporter
    , explodingRam
    , extraCrewmember
    , improvisedSludgeThrower
    , nitroBooster
    , ram
    , rollCage
    , tankTracks

    -- TODO , turretMountingForWeapon
    , louderSiren -- Highway Patrol.
    , microPlateArmour -- Verney.
    , trailer Light -- Rusty's Bootleggers.
    , trailer Middle -- Rusty's Bootleggers.
    , trailer Heavy -- Rusty's Bootleggers.
    ]


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


experimentalNuclearEngine : Upgrade
experimentalNuclearEngine =
    { defaultUpgrade
        | name = "Experimental Nuclear Engine"
        , cost = 5
        , specials =
            [ Electrical
            , GearMod 2
            , SpecialRule "This vehicle considers the Long Straight movement to be permistted in any Gear. The Long Straight is not considered either Hazardous or Trivial in any Gar."
            , SpecialRule "If this vehicle ever fails a Flip check, it is immediately Wrecked and automatically Explodes. When this vehicle Explodes, it counts as Heavyweight."
            , SpecialRule "This upgrade my not be purchases for lightweight vehicles. A vehicle may purchase this upgrade once."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


experimentalTeleporter : Upgrade
experimentalTeleporter =
    { defaultUpgrade
        | name = "Experimental Teleporter"
        , cost = 7
        , specials =
            [ Electrical
            , SpecialRule "At the start of this vehicle's activation this vehicle may choose to activate the Experimental Teleporter prior to (and in addition to) its normal Movement Step. When the Experimental Teleporter is activated, this vehicle gains 3 Hazard Tokens, and then rolsl a single Skid Die."
            , SpecialRule "If the Skid Die result is any result other than a Hazard, place this vehicle anywhere within Medium range of its current position, not touching any obstructions or terrain, without altering the vehicles facing. This does not cause a Collision. This vehicle then begins its normal Movement Step from this new location."
            , SpecialRule "If the Skid Dice result is a Hazard, the player to the left of the controller of the vehicle places this vehicle wnywhere within Long range of it's current Position, not touching an obstruction or terrain, without altering it's facing. This does not cause a Collision."
            , SpecialRule "A vehicle may purchase this upgrade once."
            ]
        , requiredSponsor = stringToSponsor "Mishkin"
    }


explodingRam : Upgrade
explodingRam =
    { defaultUpgrade
        | name = "Exploding Ram"
        , cost = 3
        , specials =
            [ ammoInit 1
            , SpecialRule "When purchasing this upgrade, a facing must be declared for it, as if it was a weapon. A vehicle may only purchase this upgrade once. Lightweight vehicles may not purchase this upgrade."
            , SpecialRule "The first time this vehicle is involved in a Collision on the declared facing in a game, this vehicle must declare a Smash Attack (even if the Collision is a Tailgate). During this Smash Attack this vehicle gains +6 attack dice. If any 1s or 2s are rolled on this vehicle's attack dice during this Smash Attack, this vehicle immediately loses on hull point for each 1 or 2 rolled."
            , SpecialRule "A vehicle may equip both a Ram and an Exploding Ram on the same facing, and their effects are cumulative."
            , SpecialRule "A vehicle may only purchase one explosive ram. Bikes may not purchase this weapon."
            ]
    }


extraCrewmember : Upgrade
extraCrewmember =
    { defaultUpgrade
        | name = "Extra Crewmember"
        , specials = [ CrewMod 1, SpecialRule "Up to a maximum of twice the vehicle's starting Crew Value" ]
        , cost = 4
    }


improvisedSludgeThrower : Upgrade
improvisedSludgeThrower =
    { defaultUpgrade
        | name = "Improvised Sludge Thrower"
        , slots = 1
        , cost = 2
        , specials =
            [ SpecialRule "This vehicle may place the burst templates for its dropped weapons anywhere within a 360° arc of fire that is at least partially within medium range of this vehicle."
            ]
    }


nitroBooster : Upgrade
nitroBooster =
    { defaultUpgrade
        | name = "Nitro Booster"
        , cost = 6
        , specials =
            [ ammoInit 1
            , SpecialRule "Once per activation, at the start of a Movement Step, this vehicle may declare that it is using a Nitro Booster. If it does, this vehicle makes an immediate forced, Long Straight move forward, and then gains Hazard Tokens until it has 5 Hazard Tokens. It then resolves its Movement Step as normal, except that the vehicle may not reverse. At the end of a Movement Step in which this vehicle used Nitro Booster, it gains Hazard Tokens until it has 5 Hazard Tokens."
            ]
    }


ram : Upgrade
ram =
    { defaultUpgrade
        | name = "Ram"
        , slots = 1
        , cost = 4
        , specials =
            [ SpecialRule "The ram can represent a ram, a bulldozer blade, a cow-catcher, a buzz saw, a wreaking ball on a chain, spiked or scythed wheels, metal spikes, or any other vicious or dangerous close combat weapon attached to the vehicle."
            , SpecialRule "When purchasing this upgrade, a facing must be declared for it, as if it was a weapon. A vehicle may only purchase a single Ram on each facing."
            , SpecialRule "When involved in a collision on the declared facing, this vehicle may add +2 attack dice to its Smash Attack, and this vehicle does not gain any hazard tokens as a result of the collision."
            ]
    }


rollCage : Upgrade
rollCage =
    { defaultUpgrade
        | name = "Roll Cage"
        , slots = 1
        , cost = 4
        , specials =
            [ SpecialRule "When this vehicle suffers a Flip, this vehicle may choose to ignore the 2 hits it received from the Flip." ]
    }


tankTracks : Upgrade
tankTracks =
    { defaultUpgrade
        | name = "Tank Tracks"
        , slots = 1
        , cost = 4
        , specials =
            [ GearMod -1
            , HandlingMod 1
            , SpecialRule "The vehicle with tank tracks has had its wheels replaced with caterpillar tracks. It increases its Handling by 1 but reduces its max Gear by 1. This vehicle may also ignore rough and treacherous surfaces."
            , SpecialRule "A vehicle may on purchase this upgrade once. Tanks, Helicopters, and Gyrocopers may not purchase tank tracks."
            ]
    }



{--turretMountingForWeapon : Upgrade
turretMountingForWeapon =
    { defaultUpgrade
        | name = "Turrent Mounting For Weapon"
    }--}
-- Perk-related upgrades.
-- Highway Patrol


louderSiren : Upgrade
louderSiren =
    { defaultUpgrade
        | name = "Louder Siren"
        , slots = 0
        , cost = 2
        , specials = [ SpecialRule "Replace \"bogey\" with \"any enemy vehicle\" for the purposes of the Siren special rules." ]
        , requiredSponsor = stringToSponsor "Highway Patrol"
    }



-- Verney


microPlateArmour : Upgrade
microPlateArmour =
    { defaultUpgrade
        | name = "MicroPlate Armour"
        , slots = 0
        , cost = 6
        , specials = [ HullMod 2 ]
        , requiredSponsor = stringToSponsor "Verney"
    }


trailer : WeightClass -> Upgrade
trailer weightClass =
    let
        baseUpgrade =
            { defaultUpgrade
                | name = "Trailer"
                , specials =
                    [ NamedSpecialRule "Stowage"
                        "Middleweight trailers provide 1 additional build slot to the towing vehicle. Heavyweight trailers provide 3 additional build slots to the towing vehicle. When purchasing a weapon for a vehicle with a trailer, the player must declare whether that weapons is installed on the cab or the trailer. When measuring range, place the shooting template touching either the cab or the trailer, depending on where the weapon is mounted, as per the Articulated rules (see War Rig, page 118)."
                    ]
                , requiredSponsor = stringToSponsor "Rusty's Bootleggers"
            }
    in
    case weightClass of
        Light ->
            { baseUpgrade
                | cost = 4
            }

        Middle ->
            { baseUpgrade
                | cost = 8
                , specials = SlotMod 1 :: baseUpgrade.specials
            }

        Heavy ->
            { baseUpgrade
                | cost = 8
                , specials = SlotMod 3 :: baseUpgrade.specials
            }
