module Model.Weapons exposing (..)


type alias Weapon =
    { name : String
    , wtype : WeaponType
    , attack : Dice
    , range : Range
    , slots : Int
    , specials : List Special
    , cost : Int
    , id : Int
    }


type Special
    = Ammo Int
    | SpecialRule String
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


type Range
    = Medium
    | Double
    | TemplateLarge
    | BurstLarge
    | BurstSmall
    | SmashRange
    | NoRange


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
    Weapon "" NoWeapon (Dice 0 0) NoRange 0 [] 0 -1


handgun : Weapon
handgun =
    Weapon "Handgun"
        Shooting
        (Dice 1 6)
        Medium
        0
        [ CrewFired ]
        0
        -1


machineGun : Weapon
machineGun =
    Weapon "Machine Gun"
        Shooting
        (Dice 2 6)
        Double
        1
        []
        2
        -1


heavyMachineGun : Weapon
heavyMachineGun =
    Weapon "Heavy Machine Gun"
        Shooting
        (Dice 3 6)
        Double
        1
        []
        4
        -1


miniGun : Weapon
miniGun =
    Weapon "Mini-Gun"
        Shooting
        (Dice 4 6)
        Double
        1
        []
        6
        -1


oneTwentyFiveMMCannon : Weapon
oneTwentyFiveMMCannon =
    Weapon "125mm Cannon"
        Shooting
        (Dice 8 6)
        Double
        3
        [ Ammo 3, SpecialRule "TBD" ]
        6
        -1


rockets : Weapon
rockets =
    Weapon "Rockets"
        Shooting
        (Dice 6 6)
        Double
        2
        [ Ammo 3, Blast, HighlyExplosive ]
        4
        -1


flamethrower : Weapon
flamethrower =
    Weapon "Flamethrower"
        Shooting
        (Dice 6 6)
        TemplateLarge
        2
        [ Ammo 3, Fire, Explosive ]
        6
        -1


mortar : Weapon
mortar =
    Weapon "Mortar"
        Shooting
        (Dice 4 6)
        Double
        1
        [ Ammo 3, SpecialRule "TBD" ]
        4
        -1


grenades : Weapon
grenades =
    Weapon "Grenades"
        Shooting
        (Dice 1 6)
        Medium
        0
        [ Ammo 5, CrewFired, Blast, Explosive, Blitz ]
        1
        -1


molotovCocktails : Weapon
molotovCocktails =
    Weapon "Molotov Cocktails"
        Shooting
        (Dice 1 6)
        Medium
        0
        [ Ammo 5, CrewFired, Fire, Blitz ]
        1
        -1


oilSlickDropper : Weapon
oilSlickDropper =
    Weapon "Oil Slick Dropper"
        Dropped
        (Dice 0 0)
        BurstLarge
        0
        [ Ammo 3, SpecialRule "TBD" ]
        2
        -1


caltropDropper : Weapon
caltropDropper =
    Weapon "Caltrop Dropper"
        Dropped
        (Dice 0 0)
        BurstSmall
        1
        [ Ammo 3, SpecialRule "TBD" ]
        1
        -1


glueDropper : Weapon
glueDropper =
    Weapon "Glue Dropper"
        Dropped
        (Dice 0 0)
        BurstLarge
        1
        [ Ammo 1, SpecialRule "TBD" ]
        1
        -1


mines : Weapon
mines =
    Weapon "Mines"
        Dropped
        (Dice 1 6)
        BurstSmall
        1
        [ Ammo 1, Blast ]
        1
        -1


smoke : Weapon
smoke =
    Weapon "Smoke"
        Dropped
        (Dice 0 0)
        BurstLarge
        0
        [ Ammo 3, SpecialRule "TBD" ]
        1
        -1


ram : Weapon
ram =
    Weapon "Ram"
        SmashType
        (Dice 1 6)
        SmashRange
        1
        [ SpecialRule "TBD" ]
        4
        -1


explodingRam : Weapon
explodingRam =
    Weapon "Exploding Ram"
        SmashType
        (Dice 1 6)
        SmashRange
        1
        [ Ammo 1, HighlyExplosive, SpecialRule "TBD" ]
        3
        -1


thumper : Weapon
thumper =
    Weapon "Thumper"
        Shooting
        (Dice 0 0)
        Medium
        2
        [ Electrical, Ammo 1, SpecialRule "TBD" ]
        4
        -1


arcLightningProjector : Weapon
arcLightningProjector =
    Weapon "Arc Lightning Projector"
        Shooting
        (Dice 1 6)
        Double
        2
        [ Electrical, Ammo 1, SpecialRule "TBD" ]
        6
        -1


kineticSuperBooster : Weapon
kineticSuperBooster =
    Weapon "Kinetic Super Booster"
        Shooting
        (Dice 1 6)
        Double
        2
        [ Electrical, Ammo 1, SpecialRule "TBD" ]
        6
        -1


magneticJammer : Weapon
magneticJammer =
    Weapon "Magnetic Jammer"
        Shooting
        (Dice 0 0)
        Double
        0
        [ Electrical, SpecialRule "TBD" ]
        2
        -1


rollDice : Dice -> Int
rollDice dice =
    -100
