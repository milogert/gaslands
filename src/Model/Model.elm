module Model.Model exposing (CurrentView(..), ErrorType(..), Model, Msg(..), init, totalPoints, viewToStr, errorToStr)

import Json.Decode exposing (int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


type alias Model =
    { view : CurrentView
    , pointsAllowed : Int
    , vehicles : List Vehicle
    , tmpVehicle : Maybe Vehicle
    , tmpWeapon : Maybe Weapon
    , tmpUpgrade : Maybe Upgrade
    , error : List ErrorType
    }


modelDecoder : Decoder Model
modelDecoder =
    decode Model
        |> hardcoded Overview
        |> required "pointsAllowed" int
        |> required "vehicles" (list vehicleDecoder)
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded []
    
type CurrentView
    = Overview
    | Details Vehicle
    | AddingVehicle
    | AddingWeapon Vehicle
    | AddingUpgrade Vehicle
    | ImportExport


type ErrorType
    = VehicleNameError
    | VehicleTypeError
    | WeaponTypeError
    | UpgradeTypeError


errorToStr : ErrorType -> String
errorToStr e =
    case e of
        VehicleNameError ->
            "Vehicle requires a name."

        VehicleTypeError ->
            "Vehicle requires a type."

        WeaponTypeError ->
            "Select a weapon from the dropdown to add."

        UpgradeTypeError ->
            "Select an upgrade from the dropdown to add."


viewToStr : CurrentView -> String
viewToStr view =
    case view of
        Overview ->
            toString view

        Details v ->
            "Details for " ++ v.name

        AddingVehicle ->
            "Adding Vehicle"

        AddingWeapon v ->
            "Adding Weapon to " ++ v.name

        AddingUpgrade v ->
            "Adding Upgrade to " ++ v.name

        ImportExport ->
            "Import/Export"


totalPoints : Model -> Int
totalPoints model =
    List.sum <| List.map vehicleCost model.vehicles


init : ( Model, Cmd Msg )
init =
    Model
        Overview
        50
        []
        Nothing
        Nothing
        Nothing
        []
        ! []


type Msg
    = ToOverview
    | ToDetails Vehicle
    | ToNewVehicle
    | ToNewWeapon Vehicle
    | ToNewUpgrade Vehicle
    | ToExport
    | AddVehicle
    | AddWeapon Vehicle
    | AddUpgrade Vehicle
    | DeleteVehicle Vehicle
    | DeleteWeapon Vehicle Weapon
    | DeleteUpgrade Vehicle Upgrade
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | UpdateActivated Vehicle Bool
    | UpdateGear Vehicle String
    | UpdateHull Vehicle String
    | UpdateCrew Vehicle String
    | UpdateEquipment Vehicle String
    | UpdateNotes Bool Vehicle String
    | TmpWeaponUpdate String
    | TmpUpgradeUpdate String
    | UpdatePointsAllowed String
    | Export
