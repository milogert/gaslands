module Model.Model exposing (CurrentView(..), ErrorType(..), Model, Msg(..), init, totalPoints, viewToStr, errorToStr)

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
    , error : List ErrorType
    }


type CurrentView
    = Overview
    | Details Int Vehicle
    | AddingVehicle
    | AddingWeapon Int Vehicle
    | AddingUpgrade Int Vehicle


type ErrorType
    = VehicleNameError
    | VehicleTypeError


errorToStr : ErrorType -> String
errorToStr e =
    case e of
        VehicleNameError ->
            "Vehicle requires a name."

        VehicleTypeError ->
            "Vehicle requires a type."


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
    List.sum <| List.map vehicleCost model.vehicles


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
        []
        ! []


type Msg
    = ToOverview
    | ToDetails Int Vehicle
    | ToNewVehicle
    | ToNewWeapon Int Vehicle
    | ToNewUpgrade Int Vehicle
    | AddVehicle
    | AddWeapon Int Vehicle
    | AddUpgrade Int Vehicle
    | DeleteVehicle Int
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | UpdateActivated Int Vehicle Bool
    | UpdateHull Int Vehicle String
    | UpdateCrew Int Vehicle String
    | UpdateGear Int Vehicle String
    | UpdateNotes Bool Int Vehicle String
    | TmpWeaponUpdate String
    | TmpUpgradeUpdate String
    | UpdatePointsAllowed String
