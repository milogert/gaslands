module Model.Encoders.Weapons exposing (weaponEncoder, specialEncoder)

import Json.Encode exposing (..)
import Model.Weapons exposing (..)


weaponEncoder : Weapon -> Value
weaponEncoder w =
    object 
        [ ("name", string w.name)
        , ("wtype", string <| toString w.wtype)
        , ("mountPoint", mountPointEncoder w.mountPoint)
        , ("attack", diceEncoder w.attack)
        , ("range", string <| toString w.range)
        , ("slots", int w.slots)
        , ("specials", list <| List.map specialEncoder w.specials)
        , ("cost", int w.cost)
        , ("id", int w.id)
        , ("status", weaponStatusEncoder w.status)
        , ("ammoUsed", int w.ammoUsed)
        ]


mountPointEncoder : Maybe WeaponMounting -> Value
mountPointEncoder maybePoint =
    case maybePoint of
        Just point ->
            string <| toString point

        Nothing ->
            null


specialEncoder : Special -> Value
specialEncoder s =
    case s of
        Ammo i -> ammoEncoder i
        SpecialRule t -> specialRuleEncoder t
        TreacherousSurface -> genericEncoder s
        Blast -> genericEncoder s
        Fire -> genericEncoder s
        Explosive -> genericEncoder s
        Blitz -> genericEncoder s
        HighlyExplosive -> genericEncoder s
        Electrical -> genericEncoder s
        HandlingMod i -> modEncoder s i
        HullMod i -> modEncoder s i
        GearMod i -> modEncoder s i
        CrewMod i -> modEncoder s i


ammoEncoder : Int -> Value
ammoEncoder i =
    object [ ("type", string "Ammo"), ("count", int i) ]


specialRuleEncoder : String -> Value
specialRuleEncoder t =
    object [ ("type", string "SpecialRule"), ("text", string t) ]


genericEncoder : Special -> Value
genericEncoder s =
    object [ ("type", string <| toString s) ]


modEncoder : Special -> Int -> Value
modEncoder s i =
    object [ ("type", string <| toString s), ("modifier", int i) ]


diceEncoder : Dice -> Value
diceEncoder d =
    object [ ("number", int d.number), ("die", int d.die) ]


weaponStatusEncoder : WeaponStatus -> Value
weaponStatusEncoder ws =
    string <| toString ws
