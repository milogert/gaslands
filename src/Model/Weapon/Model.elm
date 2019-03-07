module Model.Weapon.Model exposing
    ( Dice
    , Range(..)
    , Weapon
    , WeaponMounting(..)
    , WeaponStatus(..)
    , WeaponType(..)
    , defaultWeapon
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)


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
    , status : WeaponStatus
    , requiredSponsor : Maybe Sponsor
    , expansion : Expansion
    }


type WeaponType
    = Shooting
    | Dropped
    | SmashType


type WeaponMounting
    = Full
    | Front
    | LeftSide
    | RightSide
    | Rear
    | CrewFired


type Range
    = Short
    | Medium
    | Double
    | TemplateLarge
    | BurstSmall
    | BurstLarge
    | SmashRange
    | SpecialRange String


type WeaponStatus
    = WeaponReady
    | WeaponFired


type alias Dice =
    { number : Int
    , die : Int
    }


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
        WeaponReady
        Nothing
        BaseGame
