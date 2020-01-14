module Model.Weapon exposing
    ( Dice
    , Range(..)
    , Weapon
    , WeaponEvent(..)
    , WeaponMounting(..)
    , WeaponStatus(..)
    , defaultWeapon
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (..)


type WeaponEvent
    = AddWeapon String Weapon
    | DeleteWeapon String Weapon
    | UpdateAmmoUsed String Weapon Int Bool
    | TmpWeaponUpdate String
    | TmpWeaponMountPoint String
    | SetWeaponsReady
    | SetWeaponFired String Weapon
    | RollWeaponDie String Weapon Int


type alias Weapon =
    { name : String
    , mountPoint : Maybe WeaponMounting
    , attack : Maybe Dice
    , attackRoll : Int
    , range : Range
    , slots : Int
    , specials : List Special
    , cost : Int
    , status : WeaponStatus
    , requiredSponsor : Maybe Sponsor
    , category : Category
    }


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
    | Long
    | Double
    | TemplateLarge
    | BurstRange Size
    | SmashRange
    | SpecialRange String
    | Dropped


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
        Nothing
        Nothing
        0
        Medium
        0
        []
        0
        WeaponReady
        Nothing
        Basic
