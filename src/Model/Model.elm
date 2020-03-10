module Model.Model exposing
    ( ErrorType(..)
    , Model
    , Msg(..)
    , defaultModel
    , errorToStr
    , init
    , totalPoints
    , vehicleFromKey
    , viewToStr
    )

import Dict exposing (Dict)
import Model.Features
import Model.Settings exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Vehicle exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Views exposing (NewType(..), ViewEvent(..))
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)
import Ports.Storage exposing (StorageEntry)
import Task
import Time
import Update.UtilsGeneric exposing (do)


type alias Model =
    { navOpen : Bool
    , view : ViewEvent
    , tabOpened : Maybe ViewEvent
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
    , storageData : List StorageEntry
    , settings : Settings
    , featureFlags : Dict String Bool
    , storageKey : String
    }


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

        ViewNew newType ->
            case newType of
                NewVehicle ->
                    "New Vehicle"

                NewWeapon key ->
                    case vehicleFromKey model key of
                        Nothing ->
                            "Not a vehicle"

                        Just { name } ->
                            "New Weapon for " ++ name

                NewUpgrade key ->
                    case vehicleFromKey model key of
                        Nothing ->
                            "Not a vehicle"

                        Just { name } ->
                            "New Upgrade for " ++ name

        ViewDetails key ->
            case vehicleFromKey model key of
                Nothing ->
                    "Not a vehicle"

                Just vehicle ->
                    vehicle.name

        ViewSponsor ->
            "Sponsor Select"

        ViewPrintAll ->
            "Printing " ++ String.fromInt (Dict.size model.vehicles) ++ " vehicle(s)"

        ViewPrint key ->
            "Printing vehicle"

        ViewSettings ->
            "Settings"


totalPoints : Model -> Int
totalPoints model =
    model.vehicles
        |> Dict.values
        |> List.map vehicleCost
        |> List.sum


vehicleFromKey : Model -> String -> Maybe Vehicle
vehicleFromKey model key =
    Dict.get key model.vehicles


defaultModel : Model
defaultModel =
    Model
        False
        ViewDashboard
        Nothing
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
        []
        Model.Settings.init
        Model.Features.flags
        ""


init : flags -> ( Model, Cmd Msg )
init flags =
    ( defaultModel
    , Cmd.batch
        [ do <| GetLastTeam ""
        , Task.perform CurrentTimeCallback Time.now
        ]
    )


type
    Msg
    -- APP.
    = NavToggle Bool
      -- ROUTES.
    | ViewMsg ViewEvent
    | ViewTab ViewEvent
      -- VEHICLE.
    | VehicleMsg VehicleEvent
      -- WEAPON.
    | WeaponMsg WeaponEvent
      -- UPGRADE.
    | UpgradeMsg UpgradeEvent
      -- SPONSOR.
    | SponsorUpdate String
      -- DATA.
    | GetAllStorage (List StorageEntry)
    | Import String String
    | SetImport String
    | Share String String
    | GetStorage StorageEntry
    | SetStorageCallback StorageEntry
    | SaveModel
    | LoadModel String
    | DeleteItem String
    | DeleteItemCallback String
    | GetLastTeam String
    | GetLastTeamCallback StorageEntry
    | SetLastTeam String
    | SetLastTeamCallback String
    | CurrentTimeCallback Time.Posix
      -- SETTINGS.
    | SettingsMsg SettingsEvent
    | UpdatePointsAllowed String
    | UpdateTeamName String
