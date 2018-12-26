module Model.Weapons exposing
    ( Dice
    , Range(..)
    , Weapon
    , WeaponMounting(..)
    , WeaponStatus(..)
    , WeaponType(..)
    , allWeaponsList
    , arcLightningProjector
    , caltropDropper
    , defaultWeapon
    , explodingRam
    , flamethrower
    , fromWeaponMounting
    , fromWeaponRange
    , fromWeaponStatus
    , fromWeaponType
    , glueDropper
    , grenades
    , handgun
    , heavyMachineGun
    , kineticSuperBooster
    , machineGun
    , magneticJammer
    , mines
    , miniGun
    , molotovCocktails
    , mortar
    , nameToWeapon
    , oilSlickDropper
    , oneTwentyFiveMMCannon
    , ram
    , rockets
    , rollDice
    , smoke
    , strToMountPoint
    , thumper
    , weaponCost
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (SponsorType(..))


type alias Weapon =
    { name : String
    , wtype : WeaponType
    , mountPoint : Maybe WeaponMounting
    , attack : Maybe Dice
    , attackRoll : Int
    , range : Range
    , slots : Int
    , specials : List Special
    , cost : Int
    , id : Int
    , status : WeaponStatus
    , requiredSponsor : Maybe SponsorType
    }


type WeaponType
    = Shooting
    | Dropped
    | SmashType


fromWeaponType : WeaponType -> String
fromWeaponType wt =
    case wt of
        Shooting ->
            "Shooting"

        Dropped ->
            "Dropped"

        SmashType ->
            "Smashing"


type WeaponMounting
    = Full
    | Front
    | LeftSide
    | RightSide
    | Rear
    | CrewFired


fromWeaponMounting : WeaponMounting -> String
fromWeaponMounting point =
    case point of
        Full ->
            "360° mounted"

        Front ->
            "Front mounted"

        LeftSide ->
            "Left mounted"

        RightSide ->
            "Right mounted"

        Rear ->
            "Rear mounted"

        CrewFired ->
            "Crew fired"


strToMountPoint : String -> Maybe WeaponMounting
strToMountPoint point =
    case point of
        "360° mounted" ->
            Just Full

        "Front mounted" ->
            Just Front

        "Left mounted" ->
            Just LeftSide

        "Right mounted" ->
            Just RightSide

        "Rear mounted" ->
            Just Rear

        "Crew fired" ->
            Just CrewFired

        _ ->
            Nothing


type Range
    = Medium
    | Double
    | TemplateLarge
    | BurstLarge
    | BurstSmall
    | SmashRange


fromWeaponRange : Range -> String
fromWeaponRange range =
    case range of
        Medium ->
            "Medium"

        Double ->
            "Double"

        TemplateLarge ->
            "Large"

        BurstLarge ->
            "Large Burst"

        BurstSmall ->
            "Small Burst"

        SmashRange ->
            "Smash"


type WeaponStatus
    = WeaponReady
    | WeaponFired


fromWeaponStatus : WeaponStatus -> String
fromWeaponStatus status =
    case status of
        WeaponReady ->
            "Ready"

        WeaponFired ->
            "Fired"


type alias Dice =
    { number : Int
    , die : Int
    }


allWeaponsList : List Weapon
allWeaponsList =
    [ handgun
    , machineGun
    , heavyMachineGun
    , miniGun
    , oneTwentyFiveMMCannon
    , rockets
    , flamethrower
    , mortar
    , grenades
    , molotovCocktails
    , oilSlickDropper
    , caltropDropper
    , glueDropper
    , mines
    , smoke
    , ram
    , explodingRam
    , thumper
    , arcLightningProjector
    , kineticSuperBooster
    , magneticJammer
    ]


nameToWeapon : String -> Maybe Weapon
nameToWeapon s =
    case s of
        "Handgun" ->
            Just handgun

        "Machine Gun" ->
            Just machineGun

        "Heavy Machine Gun" ->
            Just heavyMachineGun

        "Mini-Gun" ->
            Just miniGun

        "125mm Cannon" ->
            Just oneTwentyFiveMMCannon

        "Rockets" ->
            Just rockets

        "Flamethrower" ->
            Just flamethrower

        "Mortar" ->
            Just mortar

        "Grenades" ->
            Just grenades

        "Molotov Cocktails" ->
            Just molotovCocktails

        "Oil Slick Dropper" ->
            Just oilSlickDropper

        "Caltrop Dropper" ->
            Just caltropDropper

        "Glue Dropper" ->
            Just glueDropper

        "Mines" ->
            Just mines

        "Smoke" ->
            Just smoke

        "Ram" ->
            Just ram

        "Exploding Ram" ->
            Just explodingRam

        "Thumper" ->
            Just thumper

        "Arc Lightning Projector" ->
            Just arcLightningProjector

        "Kinetic Super Booster" ->
            Just kineticSuperBooster

        "Magnetic Jammer" ->
            Just magneticJammer

        _ ->
            Nothing


defaultWeapon : Weapon
defaultWeapon =
    Weapon
        ""
        Shooting
        Nothing
        Nothing
        0
        Medium
        0
        []
        0
        -1
        WeaponReady
        Nothing


handgun : Weapon
handgun =
    { defaultWeapon
        | name = "Handgun"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , attack = Just (Dice 1 6)
        , range = Medium
    }


machineGun : Weapon
machineGun =
    { defaultWeapon
        | name = "Machine Gun"
        , wtype = Shooting
        , attack = Just (Dice 2 6)
        , range = Double
        , slots = 1
        , cost = 2
    }


heavyMachineGun : Weapon
heavyMachineGun =
    { defaultWeapon
        | name = "Heavy Machine Gun"
        , wtype = Shooting
        , attack = Just (Dice 3 6)
        , range = Double
        , slots = 1
        , cost = 4
    }


miniGun : Weapon
miniGun =
    let
        def =
            defaultWeapon
    in
    { def
        | name = "Mini-Gun"
        , wtype = Shooting
        , attack = Just (Dice 4 6)
        , cost = 6
        , range = Double
        , slots = 1
    }


oneTwentyFiveMMCannon : Weapon
oneTwentyFiveMMCannon =
    { defaultWeapon
        | name = "125mm Cannon"
        , wtype = Shooting
        , attack = Just (Dice 8 6)
        , range = Double
        , slots = 3
        , specials =
            [ Ammo [ False, False, False ]
            , SpecialRule "A tank gun is a ridiculous weapon for a civilian vehicle to carry. When fired, the active vehicle immediately gains +2 hazard tokens if it is not a Tank."
            ]
        , cost = 6
    }


rockets : Weapon
rockets =
    { defaultWeapon
        | name = "Rockets"
        , wtype = Shooting
        , attack = Just (Dice 6 6)
        , range = Double
        , slots = 2
        , specials = [ Ammo [ False, False, False ], Blast, HighlyExplosive ]
        , cost = 4
    }


flamethrower : Weapon
flamethrower =
    { defaultWeapon
        | name = "Flamethrower"
        , wtype = Shooting
        , attack = Just (Dice 6 6)
        , range = TemplateLarge
        , slots = 2
        , specials = [ Ammo [ False, False, False ], Fire, Explosive ]
        , cost = 6
    }


mortar : Weapon
mortar =
    { defaultWeapon
        | name = "Mortar"
        , wtype = Shooting
        , attack = Just (Dice 4 6)
        , range = Double
        , slots = 1
        , specials = [ Ammo [ False, False, False ], SpecialRule "When making a shooting attack with the Mortar, the vehicle may ignore terrain and cover during the attack." ]
        , cost = 4
    }


grenades : Weapon
grenades =
    { defaultWeapon
        | name = "Grenades"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , attack = Just (Dice 1 6)
        , range = Medium
        , specials = [ Ammo [ False, False, False, False, False ], Blast, Explosive, Blitz ]
        , cost = 1
    }


molotovCocktails : Weapon
molotovCocktails =
    { defaultWeapon
        | name = "Molotov Cocktails"
        , wtype = Shooting
        , mountPoint = Just CrewFired
        , attack = Just (Dice 1 6)
        , range = Medium
        , specials = [ Ammo [ False, False, False, False, False ], Fire, Blitz ]
        , cost = 1
    }


oilSlickDropper : Weapon
oilSlickDropper =
    { defaultWeapon
        | name = "Oil Slick Dropper"
        , wtype = Dropped
        , range = BurstLarge
        , specials = [ Ammo [ False, False, False ], TreacherousSurface ]
        , cost = 2
    }


caltropDropper : Weapon
caltropDropper =
    { defaultWeapon
        | name = "Caltrop Dropper"
        , wtype = Dropped
        , range = BurstSmall
        , slots = 1
        , specials =
            [ Ammo [ False, False, False ]
            , TreacherousSurface
            , SpecialRule "If any part of a vehicle's maneuver template or final position overlaps the caltrops burst template, that vehicle immediately loses 2 hull points and then that caltrops template is removed."
            ]
        , cost = 1
    }


glueDropper : Weapon
glueDropper =
    { defaultWeapon
        | name = "Glue Dropper"
        , wtype = Dropped
        , range = BurstLarge
        , slots = 1
        , specials =
            [ Ammo [ False ]
            , TreacherousSurface
            , SpecialRule "Any vehicle that either starts its activation touching the template, or whose maneuver template or final position overlaps the dropped weapon template during its activation, reduces its current gear by 2 at the end of their activation."
            ]
        , cost = 1
    }


mines : Weapon
mines =
    { defaultWeapon
        | name = "Mines"
        , wtype = Dropped
        , attack = Just (Dice 1 6)
        , range = BurstSmall
        , slots = 1
        , specials = [ Ammo [ False ], Blast ]
        , cost = 1
    }


smoke : Weapon
smoke =
    { defaultWeapon
        | name = "Smoke"
        , wtype = Dropped
        , range = BurstLarge
        , specials = [ Ammo [ False, False, False ], SpecialRule "The dropped weapon template for smoke counts as a rough surface, and counts as an obstruction for the purposes of determining cover." ]
        , cost = 1
    }


ram : Weapon
ram =
    { defaultWeapon
        | name = "Ram"
        , wtype = SmashType
        , attack = Just (Dice 1 6)
        , range = SmashRange
        , slots = 1
        , specials =
            [ SpecialRule "The ram can represent a ram, a bulldozer blad, a cow-catcher, a buzz saw, a wreaking ball on a chain, spiked or scythed wheels, metal spikes, or any other vicious or dangerous close combat weapon attached to the vehicle."
            , SpecialRule "When involved in a collision on the declared facing, this vehicle may add +2 attack dice to its smash attack. When involved in a collision during its own activation, this vehicle does not gain any hazard tokens as a result of the collision."
            , SpecialRule "A vehicle may only purchase a ram once on each facing."
            ]
        , cost = 4
    }


explodingRam : Weapon
explodingRam =
    { defaultWeapon
        | name = "Exploding Ram"
        , wtype = SmashType
        , attack = Just (Dice 1 6)
        , range = SmashRange
        , slots = 1
        , specials =
            [ Ammo [ False ]
            , HighlyExplosive
            , SpecialRule "When involved in a collision on the declared facing, for the first time in a game, this vehicle must declare a smash attach (even if the collision is a tailgate) and this becomes an EXPLOSIVE SMASH ATTACK. When making an explosive smash attack this vehicle gains +6 attack dice. If any 1s or 2s are rolled on this vehicle's attack dice during this explosive smash attack, this vehicle immediately loses one hull point for each 1 or 2 rolled."
            , SpecialRule "A vehicle may only purchase one explosive ram. Bikes may not purchase this weapon."
            ]
        , cost = 3
    }


thumper : Weapon
thumper =
    { defaultWeapon
        | name = "Thumper"
        , wtype = Shooting
        , range = Medium
        , slots = 2
        , specials =
            [ Electrical
            , Ammo [ False ]
            , SpecialRule "The Thumper is a powerful sonic device that emits a shock wave that hurls nearby vehicles into the air. When this vehicle declares an attack with the Thumper, every other vehicle (friend or foe) within medium range of this vehicle immeditaly makes a flip check, in which they count their current gear as 2 higher, up to a maximum of 6. The Thumper may only be fired once per turn."
            ]
        , cost = 4
        , requiredSponsor = Just Mishkin
    }


arcLightningProjector : Weapon
arcLightningProjector =
    { defaultWeapon
        | name = "Arc Lightning Projector"
        , wtype = Shooting
        , attack = Just (Dice 1 6)
        , range = Double
        , slots = 2
        , specials =
            [ Electrical
            , Ammo [ False ]
            , SpecialRule "The Arc Lightning Projector is a dangerous electrical weapon that can arc electricity across multiple conductive targets. After damaging a target, this vehicle must immediately attack another target within short range and a 360 degree arc of fire of the current target. This chain-reaction continues until the weapon fails to damage a target, or there are nor further viable targets. This vehicle can target friendly vehicles with the Arc Lightning Projector. This vehicle cannot target the same vehicle twice in a single attack step with the Arc Lightning Projetor."
            ]
        , cost = 6
        , requiredSponsor = Just Mishkin
    }


kineticSuperBooster : Weapon
kineticSuperBooster =
    { defaultWeapon
        | name = "Kinetic Super Booster"
        , wtype = Shooting
        , attack = Just (Dice 1 6)
        , range = Double
        , slots = 2
        , specials =
            [ Electrical
            , Ammo [ False ]
            , SpecialRule "The Kinetic Super Booster is a bizarre electrical weapon that transfers a jolt of kinetic energy to the energy."
            , SpecialRule "The target of a Super Booster attack suffers no damage, but instread immediately increases its current gear by one for every successful hit, without gaining hazard tokens."
            , SpecialRule "The Super Booster may not increase a vehicle's current gar beyond its max gear."
            ]
        , cost = 6
        , requiredSponsor = Just Mishkin
    }


magneticJammer : Weapon
magneticJammer =
    { defaultWeapon
        | name = "Magnetic Jammer"
        , wtype = Shooting
        , range = Double
        , specials =
            [ Electrical
            , SpecialRule "The target vehicle may not discard ammo tokens during its next activation."
            ]
        , cost = 2
        , requiredSponsor = Just Mishkin
    }


rollDice : Dice -> Int
rollDice dice =
    -100


weaponCost : Weapon -> Int
weaponCost w =
    let
        baseCost =
            w.cost

        mountModifier =
            case w.mountPoint of
                Just Full ->
                    (*) 3

                _ ->
                    (*) 1

        totalModifier =
            mountModifier << (*) 1
    in
    totalModifier <| baseCost
