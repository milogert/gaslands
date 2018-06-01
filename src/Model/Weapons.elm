module Model.Weapons exposing (..)


type alias Weapon =
    { name : String
    , wtype : WeaponType
    , mountPoint : Maybe WeaponMounting
    , attack : Dice
    , attackRoll : List Int
    , range : Range
    , slots : Int
    , specials : List Special
    , cost : Int
    , id : Int
    , status : WeaponStatus
    }


type Special
    = Ammo Int
    | SpecialRule String
    | TreacherousSurface
    | Blast
    | Fire
    | Explosive
    | Blitz
    | CrewFired
    | HighlyExplosive
    | Electrical
    | HandlingMod Int
    | HullMod Int
    | GearMod Int
    | CrewMod Int


type WeaponType
    = Shooting
    | Dropped
    | SmashType
    | NoWeapon


type WeaponMounting
    = Full
    | Front
    | LeftSide
    | RightSide
    | Rear


type Range
    = Medium
    | Double
    | TemplateLarge
    | BurstLarge
    | BurstSmall
    | SmashRange
    | NoRange


type WeaponStatus
    = WeaponReady
    | WeaponFired


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


nameToWeapon : String -> Weapon
nameToWeapon s =
    case s of
        "Handgun" ->
            handgun

        "Machine Gun" ->
            machineGun

        "Heavy Machine Gun" ->
            heavyMachineGun

        "Mini-Gun" ->
            miniGun

        "125mm Cannon" ->
            oneTwentyFiveMMCannon

        "Rockets" ->
            rockets

        "Flamethrower" ->
            flamethrower

        "Mortar" ->
            mortar

        "Grenades" ->
            grenades

        "Molotov Cocktails" ->
            molotovCocktails

        "Oil Slick Dropper" ->
            oilSlickDropper

        "Caltrop Dropper" ->
            caltropDropper

        "Glue Dropper" ->
            glueDropper

        "Mines" ->
            mines

        "Smoke" ->
            smoke

        "Ram" ->
            ram

        "Exploding Ram" ->
            explodingRam

        "Thumper" ->
            thumper

        "Arc Lightning Projector" ->
            arcLightningProjector

        "Kinetic Super Booster" ->
            kineticSuperBooster

        "Magnetic Jammer" ->
            magneticJammer

        _ ->
            defaultWeapon


defaultWeapon : Weapon
defaultWeapon =
    Weapon "" NoWeapon Nothing (Dice 0 0) [] NoRange 0 [] 0 -1 WeaponReady


handgun : Weapon
handgun =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Handgun"
            , wtype = Shooting
            , mountPoint = Just Full
            , attack = Dice 1 6
            , range = Medium
            , specials = [ CrewFired ]
        }


machineGun : Weapon
machineGun =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Machine Gun"
            , wtype = Shooting
            , attack = (Dice 2 6)
            , range = Double
            , slots = 1
            , cost = 2
        }


heavyMachineGun : Weapon
heavyMachineGun =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Heavy Machine Gun"
            , wtype = Shooting
            , attack = (Dice 3 6)
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
            , attack = Dice 4 6
            , cost = 6
            , range = Double
            , slots = 1
            , cost = 6
        }


oneTwentyFiveMMCannon : Weapon
oneTwentyFiveMMCannon =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "125mm Cannon"
            , wtype = Shooting
            , attack = (Dice 8 6)
            , range = Double
            , slots = 3
            , specials =
                [ Ammo 3
                , SpecialRule "A tank gun is a ridiculous weapon for a civilian vehicle to carry. When fired, the active vehicle immediately gains +2 hazard tokens if it is not a Tank."
                ]
            , cost = 6
        }


rockets : Weapon
rockets =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Rockets"
            , wtype = Shooting
            , attack = (Dice 6 6)
            , range = Double
            , slots = 2
            , specials = [ Ammo 3, Blast, HighlyExplosive ]
            , cost = 4
        }


flamethrower : Weapon
flamethrower =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Flamethrower"
            , wtype = Shooting
            , attack = (Dice 6 6)
            , range = TemplateLarge
            , slots = 2
            , specials = [ Ammo 3, Fire, Explosive ]
            , cost = 6
        }


mortar : Weapon
mortar =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Mortar"
            , wtype = Shooting
            , attack = (Dice 4 6)
            , range = Double
            , slots = 1
            , specials = [ Ammo 3, SpecialRule "When making a shooting attack with the Mortar, the vehicle may ignore terrain and cover during the attack." ]
            , cost = 4
        }


grenades : Weapon
grenades =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Grenades"
            , wtype = Shooting
            , mountPoint = Just Full
            , attack = (Dice 1 6)
            , range = Medium
            , specials = [ Ammo 5, CrewFired, Blast, Explosive, Blitz ]
            , cost = 1
        }


molotovCocktails : Weapon
molotovCocktails =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Molotov Cocktails"
            , wtype = Shooting
            , mountPoint = Just Full
            , attack = (Dice 1 6)
            , range = Medium
            , specials = [ Ammo 5, CrewFired, Fire, Blitz ]
            , cost = 1
        }


oilSlickDropper : Weapon
oilSlickDropper =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Oil Slick Dropper"
            , wtype = Dropped
            , range = BurstLarge
            , specials = [ Ammo 3, TreacherousSurface ]
            , cost = 2
        }


caltropDropper : Weapon
caltropDropper =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Caltrop Dropper"
            , wtype = Dropped
            , range = BurstSmall
            , slots = 1
            , specials =
                [ Ammo 3
                , TreacherousSurface
                , SpecialRule "If any part of a vehicle's maneuver template or final position overlaps the caltrops burst template, that vehicle immediately loses 2 hull points and then that caltrops template is removed."
                ]
            , cost = 1
        }


glueDropper : Weapon
glueDropper =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Glue Dropper"
            , wtype = Dropped
            , range = BurstLarge
            , slots = 1
            , specials =
                [ Ammo 1
                , TreacherousSurface
                , SpecialRule "Any vehicle that either starts its activation touching the template, or whose maneuver template or final position overlaps the dropped weapon template during its activation, reduces its current gear by 2 at the end of their activation."
                ]
            , cost = 1
        }


mines : Weapon
mines =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Mines"
            , wtype = Dropped
            , attack = (Dice 1 6)
            , range = BurstSmall
            , slots = 1
            , specials = [ Ammo 1, Blast ]
            , cost = 1
        }


smoke : Weapon
smoke =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Smoke"
            , wtype = Dropped
            , range = BurstLarge
            , specials = [ Ammo 3, SpecialRule "The dropped weapon template for smoke counts as a rough surface, and counts as an obstruction for the purposes of determining cover." ]
            , cost = 1
        }


ram : Weapon
ram =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Ram"
            , wtype = SmashType
            , attack = (Dice 1 6)
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
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Exploding Ram"
            , wtype = SmashType
            , attack = (Dice 1 6)
            , range = SmashRange
            , slots = 1
            , specials =
                [ Ammo 1
                , HighlyExplosive
                , SpecialRule "When involved in a collision on the declared facing, for the first time in a game, this vehicle must declare a smash attach (even if the collision is a tailgate) and this becomes an EXPLOSIVE SMASH ATTACK. When making an explosive smash attack this vehicle gains +6 attack dice. If any 1s or 2s are rolled on this vehicle's attack dice during this explosive smash attack, this vehicle immediately loses one hull point for each 1 or 2 rolled."
                , SpecialRule "A vehicle may only purchase one explosive ram. Bikes may not purchase this weapon."
                ]
            , cost = 3
        }


thumper : Weapon
thumper =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Thumper"
            , wtype = Shooting
            , range = Medium
            , slots = 2
            , specials =
                [ Electrical
                , Ammo 1
                , SpecialRule "The Thumper is a powerful sonic device that emits a shock wave that hurls nearby vehicles into the air. When this vehicle declares an attack with the Thumper, every other vehicle (friend or foe) within medium range of this vehicle immeditaly makes a flip check, in which they count their current gear as 2 higher, up to a maximum of 6. The Thumper may only be fired once per turn."
                ]
            , cost = 4
        }


arcLightningProjector : Weapon
arcLightningProjector =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Arc Lightning Projector"
            , wtype = Shooting
            , attack = (Dice 1 6)
            , range = Double
            , slots = 2
            , specials =
                [ Electrical
                , Ammo 1
                , SpecialRule "The Arc Lightning Projector is a dangerous electrical weapon that can arc electricity across multiple conductive targets. After damaging a target, this vehicle must immediately attack another target within short range and a 360 degree arc of fire of the current target. This chain-reaction continues until the weapon fails to damage a target, or there are nor further viable targets. This vehicle can target friendly vehicles with the Arc Lightning Projector. This vehicle cannot target the same vehicle twice in a single attack step with the Arc Lightning Projetor."
                ]
            , cost = 6
        }


kineticSuperBooster : Weapon
kineticSuperBooster =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Kinetic Super Booster"
            , wtype = Shooting
            , attack = (Dice 1 6)
            , range = Double
            , slots = 2
            , specials =
                [ Electrical
                , Ammo 1
                , SpecialRule "The Kinetic Super Booster is a bizarre electrical weapon that transfers a jolt of kinetic energy to the energy."
                , SpecialRule "The target of a Super Booster attack suffers no damage, but instread immediately increases its current gear by one for every successful hit, without gaining hazard tokens."
                , SpecialRule "The Super Booster may not increase a vehicle's current gar beyond its max gear."
                ]
            , cost = 6
        }


magneticJammer : Weapon
magneticJammer =
    let
        def =
            defaultWeapon
    in
        { def
            | name = "Magnetic Jammer"
            , wtype = Shooting
            , range = Double
            , specials =
                [ Electrical
                , SpecialRule "The target vehicle may not discard ammo tokens during its next activation."
                ]
            , cost = 2
        }


rollDice : Dice -> Int
rollDice dice =
    -100
