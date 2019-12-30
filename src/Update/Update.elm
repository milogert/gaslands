module Update.Update exposing (update)

import Dict
import Model.Model exposing (..)
import Model.Settings exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Ports.Modals
import Ports.Photo
import Ports.Storage
import Task
import Time
import Update.Data
import Update.Routes
import Update.Settings
import Update.Sponsor
import Update.Upgrade
import Update.Utils exposing (doNavClose)
import Update.UtilsGeneric exposing (do)
import Update.Vehicle
import Update.View
import Update.Weapon
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- APP.
        NavToggle toggle ->
            ( { model | navOpen = toggle }
            , Cmd.none
            )

        -- ROUTING.
        ViewMsg viewEvent ->
            Update.View.update model viewEvent

        ViewTab viewEvent ->
            ( { model | tabOpened = Just viewEvent }
            , doNavClose
            )

        -- GAME SETTINGS.
        UpdatePointsAllowed s ->
            ( { model
                | pointsAllowed = Maybe.withDefault 0 (String.toInt s)
              }
            , Cmd.none
            )

        UpdateTeamName s ->
            case s of
                "" ->
                    ( { model | teamName = Nothing }
                    , do <| SetLastTeam s
                    )

                _ ->
                    ( { model | teamName = Just s }
                    , Cmd.batch <|
                        List.map do
                            [ SetLastTeam s
                            , SaveModel
                            ]
                    )

        -- VEHICLE.
        VehicleMsg event ->
            Update.Vehicle.update model event

        -- WEAPON.
        WeaponMsg event ->
            Update.Weapon.update model event

        -- UPGRADE.
        UpgradeMsg event ->
            Update.Upgrade.update model event

        -- SPONSOR.
        SponsorUpdate sponsorName ->
            Update.Sponsor.set model <| stringToSponsor sponsorName

        -- DATA.
        GetAllStorage data ->
            ( { model | storageData = data }
            , Cmd.none
            )

        Import key jsonModel ->
            Update.Data.import_ model key jsonModel

        SetImport json ->
            ( { model | importValue = json }
            , Cmd.none
            )

        Share key jsonModel ->
            Update.Data.share model key jsonModel

        GetStorage storageEntry ->
            ( { model | importValue = storageEntry.value }
            , Cmd.none
            )

        SetStorageCallback entry ->
            ( model
            , Cmd.batch [ Ports.Storage.getStorage "", Task.perform SetImport (Task.succeed entry.value) ]
            )

        SaveModel ->
            Update.Data.saveModel model

        LoadModel key ->
            ( model
            , Ports.Storage.get key
            )

        DeleteItem key ->
            ( model
            , Ports.Storage.delete key
            )

        DeleteItemCallback deletedKey ->
            ( model
            , Ports.Storage.getStorage ""
            )

        GetLastTeam _ ->
            ( model
            , Ports.Storage.getLastTeam ""
            )

        GetLastTeamCallback { key, value } ->
            ( model
            , do <| Import key value
            )

        SetLastTeam teamName ->
            ( model
            , Ports.Storage.setLastTeam model.storageKey
            )

        SetLastTeamCallback _ ->
            ( model, Cmd.none )

        CurrentTimeCallback posixTime ->
            ( { model
                | storageKey =
                    String.fromInt <|
                        Time.posixToMillis posixTime
              }
            , Cmd.none
            )

        SettingsMsg event ->
            Update.Settings.update model event
