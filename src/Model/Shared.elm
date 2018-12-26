module Model.Shared exposing
    ( Special(..)
    , fromSpecial
    , getAmmoClip
    )

import List.Extra as ListE


type Special
    = Ammo (List Bool)
    | SpecialRule String
    | NamedSpecialRule String String
    | TreacherousSurface
    | Blast
    | Fire
    | Explosive
    | Blitz
    | HighlyExplosive
    | Electrical
    | HandlingMod Int
    | HullMod Int
    | GearMod Int
    | CrewMod Int


fromSpecial : Special -> String
fromSpecial special =
    case special of
        Ammo count ->
            "Ammo " ++ String.fromInt (List.length count)

        SpecialRule s ->
            "SpecialRule " ++ s

        NamedSpecialRule title desc ->
            "NamedSpecialRule " ++ title ++ " " ++ desc

        TreacherousSurface ->
            "TreacherousSurface"

        Blast ->
            "Blast"

        Fire ->
            "Fire"

        Explosive ->
            "Explosive"

        Blitz ->
            "Blitz"

        HighlyExplosive ->
            "HighlyExplosive"

        Electrical ->
            "Electrical"

        HandlingMod i ->
            "HandlingMod " ++ String.fromInt i

        HullMod i ->
            "HullMod " ++ String.fromInt i

        GearMod i ->
            "GearMod " ++ String.fromInt i

        CrewMod i ->
            "CrewMod " ++ String.fromInt i


getAmmoClip : List Special -> ( Maybe Int, Maybe Special )
getAmmoClip specials =
    let
        ammoFinder special =
            case special of
                Ammo _ ->
                    True

                _ ->
                    False

        mAmmoSpecial =
            ListE.find
                ammoFinder
                specials

        mAmmoSpecialIndex =
            ListE.findIndex
                ammoFinder
                specials
    in
    ( mAmmoSpecialIndex, mAmmoSpecial )
