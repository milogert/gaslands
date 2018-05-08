module Model.Model exposing (CurrentView(..), Model, Msg(..), init, totalPoints, viewToStr)

import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


type alias Model =
    { view : CurrentView
    , pointsAllowed : Int
    , vehicles : List Vehicle
    , tmpVehicle : Vehicle
    , vehicleIndex : Int
    , tmpWeapon : Weapon
    , tmpUpgrade : Upgrade
    , error : String
    }


type CurrentView
    = Overview
    | Details Int Vehicle
    | AddingVehicle
    | AddingWeapon Int Vehicle
    | AddingUpgrade Int Vehicle


viewToStr : CurrentView -> String
viewToStr view =
    case view of
        Overview ->
            toString view

        Details _ v ->
            "Details for " ++ v.name

        AddingVehicle ->
            "Adding Vehicle"

        AddingWeapon _ v ->
            "Adding Weapon to " ++ v.name

        AddingUpgrade _ v ->
            "Adding Upgrade to " ++ v.name


totalPoints : Model -> Int
totalPoints model =
    0


init : ( Model, Cmd Msg )
init =
    Model
        Overview
        50
        []
        defaultVehicle
        0
        defaultWeapon
        defaultUpgrade
        ""
        ! []


type Msg
    = ToOverview
    | ToDetails Int Vehicle
    | ToNewVehicle
    | ToNewWeapon Int Vehicle
    | ToNewUpgrade Int Vehicle
    | AddVehicle
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | UpdateActivated Int Vehicle Bool
    | UpdateHull Int Vehicle String
    | UpdateCrew Int Vehicle String
    | UpdateGear Int Vehicle String
    | UpdateNotes Bool Int Vehicle String
    | TmpWeaponUpdate String
    | AddWeapon Int Vehicle
    | TmpUpgradeUpdate String
    | AddUpgrade Int Vehicle
    | UpdatePointsAllowed String
