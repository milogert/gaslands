module Model.Model exposing (CurrentView(..), ErrorType(..), Model, Msg(..), errorToStr, init, totalPoints, viewToStr)

import Model.Sponsors exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Ports.Storage exposing (StorageEntry)


type alias Model =
    { view : CurrentView
    , teamName : Maybe String
    , pointsAllowed : Int
    , gearPhase : Int
    , vehicles : List Vehicle
    , sponsor : Maybe SponsorType
    , tmpVehicle : Maybe Vehicle
    , tmpWeapon : Maybe Weapon
    , tmpUpgrade : Maybe Upgrade
    , error : List ErrorType
    , importValue : String
    , storageKeys : List String
    }


type CurrentView
    = Overview
    | Details Vehicle
    | SelectingSponsor
    | AddingVehicle
    | AddingWeapon Vehicle
    | AddingUpgrade Vehicle
    | Settings


type ErrorType
    = VehicleNameError
    | VehicleTypeError
    | WeaponTypeError
    | WeaponMountPointError
    | UpgradeTypeError
    | JsonDecodeError String


errorToStr : ErrorType -> String
errorToStr e =
    case e of
        VehicleNameError ->
            "Vehicle requires a name."

        VehicleTypeError ->
            "Vehicle requires a type."

        WeaponTypeError ->
            "Select a weapon from the dropdown to add."

        WeaponMountPointError ->
            "Select a mount point from the dropdown."

        UpgradeTypeError ->
            "Select an upgrade from the dropdown to add."

        JsonDecodeError s ->
            "Json decode error: " ++ s


viewToStr : Model -> String
viewToStr model =
    case model.view of
        Overview ->
            "Team " ++ Maybe.withDefault "NoName" model.teamName

        Details v ->
            Maybe.withDefault "NoName" model.teamName ++ "'s Vehicle"

        SelectingSponsor ->
            "Sponsor Select"

        AddingVehicle ->
            "Adding Vehicle"

        AddingWeapon v ->
            "Adding Weapon to " ++ v.name

        AddingUpgrade v ->
            "Adding Upgrade to " ++ v.name

        Settings ->
            "Settings"


totalPoints : Model -> Int
totalPoints model =
    List.sum <| List.map vehicleCost model.vehicles


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model
        Overview
        Nothing
        50
        1
        []
        Nothing
        Nothing
        Nothing
        Nothing
        []
        ""
        []
    , Cmd.none
    )


type
    Msg
    -- ROUTES.
    = ToOverview
    | ToDetails Vehicle
    | ToSponsorSelect
    | ToNewVehicle
    | ToNewWeapon Vehicle
    | ToNewUpgrade Vehicle
    | ToSettings
      -- VEHICLE.
    | AddVehicle
    | DeleteVehicle Vehicle
    | TmpName String
    | TmpVehicleType String
    | TmpNotes String
    | NextGearPhase
    | UpdateActivated Vehicle Bool
    | UpdateGear Vehicle String
    | ShiftGear Vehicle Int Int Int
    | UpdateHazards Vehicle String
    | ShiftHazards Vehicle Int Int Int
    | UpdateHull Vehicle String
    | ShiftHull Vehicle Int Int Int
    | UpdateCrew Vehicle String
    | UpdateEquipment Vehicle String
    | UpdateNotes Vehicle String
    | SetPerkInVehicle Vehicle VehiclePerk Bool
      -- WEAPON.
    | AddWeapon Vehicle Weapon
    | DeleteWeapon Vehicle Weapon
    | UpdateAmmoUsed Vehicle Weapon Int String
    | TmpWeaponUpdate String
    | TmpWeaponMountPoint String
    | SetWeaponsReady
    | SetWeaponFired Vehicle Weapon
    | RollWeaponDie Vehicle Weapon Int
      -- UPGRADE.
    | AddUpgrade Vehicle Upgrade
    | DeleteUpgrade Vehicle Upgrade
    | TmpUpgradeUpdate String
    | UpdatePointsAllowed String
    | UpdateTeamName String
      -- SPONSOR.
    | SponsorUpdate String
      -- DATA.
    | Import
    | SetImport String
    | Share
    | GetStorage String
    | GetStorageKeys (List String)
    | SetStorageCallback StorageEntry
    | SaveModel
    | LoadModel String
    | DeleteItem String
    | DeleteItemCallback String
    | GetStream Vehicle
    | TakePhoto Vehicle
    | SetPhotoUrlCallback String
    | DiscardPhoto Vehicle
