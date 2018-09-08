module Model.Shared exposing (..)


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
