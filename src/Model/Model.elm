module Model.Model exposing
    ( CurrentView(..)
    , ErrorType(..)
    , Model
    , Msg(..)
    , defaultModel
    , errorToStr
    , init
    , totalPoints
    , viewToStr
    )

import Dict exposing (Dict)
import Model.Settings exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)
import Ports.Storage exposing (StorageEntry)


type alias Model =
    { view : CurrentView
    , teamName : Maybe String
    , pointsAllowed : Int
    , gearPhase : Int
    , vehicles : Dict String Vehicle
    , sponsor : Maybe Sponsor
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
    | ViewPrinterFriendly Vehicle


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

        ViewPrinterFriendly v ->
            "Printing " ++ v.name


totalPoints : Model -> Int
totalPoints model =
    model.vehicles
        |> Dict.values
        |> List.map vehicleCost
        |> List.sum


defaultModel : Model
defaultModel =
    Model
        ViewDashboard
        Nothing
        50
        1
        Dict.empty
        Nothing
        Nothing
        Nothing
        Nothing
        []
        ""
        []
        Model.Settings.init


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel
    , Cmd.none
    )


type
    Msg
    -- ROUTES.
    = To CurrentView
      -- VEHICLE.
    | VehicleMsg VehicleEvent
      -- WEAPON.
    | AddWeapon String Weapon
    | DeleteWeapon String Weapon
    | UpdateAmmoUsed String Weapon Int Bool
    | TmpWeaponUpdate String
    | TmpWeaponMountPoint String
    | SetWeaponsReady
    | SetWeaponFired String Weapon
    | RollWeaponDie String Weapon Int
      -- UPGRADE.
    | AddUpgrade String Upgrade
    | DeleteUpgrade String Upgrade
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
