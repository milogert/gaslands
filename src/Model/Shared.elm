module Model.Shared exposing (Special(..), fromSpecial)


type Special
    = Ammo Int
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
        Ammo i ->
            "Ammo " ++ String.fromInt i

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
