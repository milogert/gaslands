module Model.Weapons exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


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


weaponDecoder : Decoder Weapon
weaponDecoder =
    decode Weapon
        |> required "name" D.string
        |> required "wtype" wtypeDecoder
        |> required "attack" diceDecoder
        |> required "range" rangeDecoder
        |> required "slots" D.int
        --|> required "specials" (D.list specialDecoder)
        |> hardcoded []
        |> required "cost" D.int
        |> required "id" D.int


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


specialsDecoder : Decoder Special
specialsDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                --"Ammo" -> D.field "count" D.int |> D.andThen ammoHelper
                --"SpecialRule" -> D.field "text" D.int |> D.andThen D.succeed SpecialRule
                "Blast" -> D.succeed Blast
                "Fire" -> D.succeed Fire
                "Explosive" -> D.succeed Explosive
                "Blitz" -> D.succeed Blitz
                "CrewFired" -> D.succeed CrewFired
                "HighlyExplosive" -> D.succeed HighlyExplosive
                "Electrical" -> D.succeed Electrical
                --"HandlingMod" -> D.field "amount" D.int |> D.succeed HandlingMod 
                --"HullMod" -> D.field "amount" D.int |> D.succeed HullMod 
                --"GearMod" -> D.field "amount" D.int |> D.succeed GearMod 
                --"CrewMod" -> D.field "amount" D.int |> D.succeed CrewMod 
                _ -> D.fail <| str ++ " is not a valid special type"
        )


type WeaponType
    = Shooting
    | Dropped
    | SmashType


wtypeDecoder : Decoder WeaponType
wtypeDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Shooting" -> D.succeed Shooting
                "Dropped" -> D.succeed Dropped
                "SmashType" -> D.succeed SmashType
                _ -> D.fail <| str ++ " is not a valid weapon type"
        )


type Range
    = Medium
    | Double
    | TemplateLarge
    | BurstLarge
    | BurstSmall
    | SmashRange


rangeDecoder : Decoder Range
rangeDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Medium" -> D.succeed Medium
                "Double" -> D.succeed Double
                "TemplateLarge" -> D.succeed TemplateLarge
                "BurstLarge" -> D.succeed BurstLarge
                "BurstSmall" -> D.succeed BurstSmall
                "SmashRange" -> D.succeed SmashRange
                _ -> D.fail <| str ++ " is not a valid range type"
        )


type alias Dice =
    { number : Int
    , die : Int
    }


diceDecoder : Decoder Dice
diceDecoder =
    decode Dice
        |> required "number" D.int
        |> required "die" D.int


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
