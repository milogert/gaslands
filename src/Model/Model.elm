module Model.Model exposing
    ( CurrentView(..)
    , ErrorType(..)
    , Model
    , Msg(..)
    , errorToStr
    , init
    , totalPoints
    , viewToStr
    )

import Model.Settings exposing (..)
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
    , settings : Settings
    }


type CurrentView
    = ViewDashboard
    | ViewDetails Vehicle
    | ViewSelectingSponsor
    | ViewAddingVehicle
    | ViewAddingWeapon Vehicle
    | ViewAddingUpgrade Vehicle
    | ViewSettings


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
        ViewDashboard ->
            "Team " ++ Maybe.withDefault "NoName" model.teamName

        ViewDetails v ->
            v.name

        ViewSelectingSponsor ->
            "Sponsor Select"

        ViewAddingVehicle ->
            "Adding Vehicle"

        ViewAddingWeapon v ->
            "Adding Weapon to " ++ v.name

        ViewAddingUpgrade v ->
            "Adding Upgrade to " ++ v.name

        ViewSettings ->
            "Settings"


totalPoints : Model -> Int
totalPoints model =
    List.sum <| List.map vehicleCost model.vehicles


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model
        ViewDashboard
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
        Model.Settings.init
    , Cmd.none
    )


type
    Msg
    -- ROUTES.
    = To CurrentView
      -- VEHICLE.
    | VehicleMsg VehicleEvent
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
      -- SETTINGS.
    | SettingsMsg SettingsEvent
