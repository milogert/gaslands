module Update.Update exposing (update)

import Bootstrap.Modal as Modal
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
import Update.Data
import Update.Settings
import Update.Sponsor
import Update.Upgrade
import Update.Utils exposing (doSaveModel)
import Update.Vehicle
import Update.View
import Update.Weapon


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- ROUTING.
        To currentView ->
            Update.View.update model currentView

        -- GAME SETTINGS.
        UpdatePointsAllowed s ->
            ( { model
                | pointsAllowed = Maybe.withDefault 0 (String.toInt s)
              }
            , doSaveModel
            )

        UpdateTeamName s ->
            case s of
                "" ->
                    ( { model | teamName = Nothing }
                    , Cmd.none
                    )

                _ ->
                    ( { model | teamName = Just s }
                    , Cmd.none
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
        Import ->
            Update.Data.import_ model

        SetImport json ->
            ( { model | importValue = json }
            , Cmd.none
            )

        Share ->
            Update.Data.share model

        GetStorage value ->
            ( { model | importValue = value }
            , Cmd.none
            )

        GetStorageKeys keys ->
            ( { model | storageKeys = keys }
            , Cmd.none
            )

        SetStorageCallback entry ->
            ( model
            , Cmd.batch [ Ports.Storage.getKeys "", Task.perform SetImport (Task.succeed entry.value) ]
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
            , Ports.Storage.getKeys ""
            )

        SettingsMsg event ->
            Update.Settings.update model event

        -- Modals.
        ShowModal modal ->
            let
                modals =
                    Dict.insert modal Modal.shown model.modals

                cmds =
                    case modal of
                        "settings" ->
                            [ Ports.Storage.getKeys "" ]

                        _ ->
                            []
            in
            ( { model
                | modals = modals
                , tmpUpgrade = Nothing
                , tmpVehicle = Nothing
                , tmpWeapon = Nothing
              }
            , Cmd.batch <| Ports.Modals.open () :: cmds
            )

        CloseModal modal ->
            let
                modals =
                    Dict.insert modal Modal.hidden model.modals
            in
            ( { model
                | modals = modals
                , tmpUpgrade = Nothing
                , tmpVehicle = Nothing
                , tmpWeapon = Nothing
              }
            , Ports.Modals.close ()
            )
