module Model.Model exposing
    ( ErrorType(..)
    , Model
    , Msg(..)
    , defaultModel
    , errorToStr
    , init
    , totalPoints
    , viewToStr
    )

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Model.Router.Model exposing (..)
import Model.Routes exposing (Route(..))
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
import Url exposing (Url)


type alias Model =
    { view : Route
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
    , url : Url
    , key : Nav.Key
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
        RouteDashboard ->
            "Team " ++ Maybe.withDefault "NoName" model.teamName

        RouteDetails key ->
            model.vehicles
                |> Dict.get key
                |> Maybe.withDefault defaultVehicle
                |> .name

        RoutePrintAll ->
            "Printing " ++ String.fromInt (Dict.size model.vehicles) ++ " vehicle(s)"

        RoutePrint key ->
            "Printing vehicle"

        RouteSettings ->
            "Game Settings"


totalPoints : Model -> Int
totalPoints model =
    model.vehicles
        |> Dict.values
        |> List.map vehicleCost
        |> List.sum


defaultModel : Url -> Nav.Key -> Model
defaultModel =
    Model
        RouteDashboard
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


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( defaultModel url key
    , Cmd.none
    )


type
    Msg
    -- ROUTES.
    = UrlRequested UrlRequest
    | UrlChanged Url
      -- VEHICLE.
    | VehicleMsg VehicleEvent
      -- WEAPON.
    | WeaponMsg WeaponEvent
      -- UPGRADE.
    | UpgradeMsg UpgradeEvent
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
    | UpdatePointsAllowed String
    | UpdateTeamName String
      -- MODALS.
    | ShowModal String
    | CloseModal String
