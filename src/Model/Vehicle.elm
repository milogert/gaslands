module Model.Vehicle exposing
    ( GearTracker
    , HullHolder
    , SkidResult(..)
    , Vehicle
    , VehicleEvent(..)
    , WeightClass(..)
    , defaultVehicle
    )

import Model.Shared exposing (Category(..), Special)
import Model.Sponsors exposing (Sponsor, VehiclePerk)
import Model.Upgrade exposing (Upgrade)
import Model.Weapon exposing (Weapon)


type VehicleEvent
    = AddVehicle Vehicle
    | DeleteVehicle String
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | NextGearPhase
    | UpdateActivated String Bool
    | UpdateGear String String
    | ShiftGear String Int Int Int
    | UpdateHazards String String
    | ShiftHazards String Int Int Int
    | UpdateHull String String
    | ShiftHull String Int Int Int
    | UpdateCrew String String
    | UpdateEquipment String String
    | UpdateNotes String String
    | SetPerkInVehicle String VehiclePerk Bool
    | GetStream String
    | TakePhoto String
    | SetPhotoUrlCallback String
    | DiscardPhoto String


type alias Vehicle =
    { name : String
    , category : Category
    , photo : Maybe String
    , type_ : String
    , gear : GearTracker
    , hazards : Int
    , handling : Int
    , skidResults : List SkidResult
    , hull : HullHolder
    , crew : Int
    , equipment : Int
    , weight : WeightClass
    , activated : Bool
    , weapons : List Weapon
    , upgrades : List Upgrade
    , notes : String
    , cost : Int
    , key : String
    , specials : List Special
    , perks : List VehiclePerk
    , requiredSponsor : Maybe Sponsor
    }


type SkidResult
    = Hazard
    | Spin
    | Slide
    | Shift


type alias GearTracker =
    { current : Int
    , max : Int
    }


type WeightClass
    = Light
    | Middle
    | Heavy


type alias HullHolder =
    { current : Int
    , max : Int
    }


defaultVehicle : Vehicle
defaultVehicle =
    Vehicle
        ""
        Basic
        Nothing
        ""
        (GearTracker 1 0)
        0
        0
        []
        (HullHolder 0 0)
        0
        0
        Light
        False
        []
        []
        ""
        0
        ""
        []
        []
        Nothing
