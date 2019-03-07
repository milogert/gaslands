module Update.Update exposing (update)

import Model.Model exposing (..)
import Model.Settings exposing (..)
import Model.Sponsors exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Weapon.Common exposing (..)
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
        AddWeapon key w ->
            Update.Weapon.addWeapon model key w

        DeleteWeapon key w ->
            Update.Weapon.deleteWeapon model key w

        UpdateAmmoUsed key w index check ->
            Update.Weapon.updateAmmoUsed model key w index check

        TmpWeaponUpdate name ->
            let
                w =
                    nameToWeapon name
            in
            ( { model | tmpWeapon = w }
            , Cmd.none
            )

        TmpWeaponMountPoint mountPointStr ->
            let
                mountPoint =
                    strToMountPoint mountPointStr

                w =
                    case model.tmpWeapon of
                        Nothing ->
                            Nothing

                        Just tmpWeapon ->
                            Just { tmpWeapon | mountPoint = mountPoint }
            in
            ( { model | tmpWeapon = w }
            , Cmd.none
            )

        SetWeaponsReady ->
            ( model
            , Cmd.none
            )

        SetWeaponFired v w ->
            Update.Weapon.setWeaponFired model v w

        RollWeaponDie v w result ->
            Update.Weapon.rollWeaponDie model v w result

        -- UPGRADE.
        AddUpgrade v u ->
            Update.Upgrade.addUpgrade model v u

        DeleteUpgrade v u ->
            Update.Upgrade.deleteUpgrade model v u

        TmpUpgradeUpdate name ->
            let
                u =
                    nameToUpgrade name
            in
            ( { model | tmpUpgrade = u }
            , Cmd.none
            )

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
