module Update.Settings exposing (update)

import Model.Model exposing (..)
import Model.Settings exposing (..)
import Task
import Time


update : Model -> SettingsEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        GenerateTeam ->
            ( model, Cmd.none )

        NewTeamVersion ->
            ( model, Task.perform CurrentTimeCallback Time.now )

        UpdateVehicleCount _ ->
            ( model, Cmd.none )

        UpdateWeaponCount _ ->
            ( model, Cmd.none )

        UpdateUpgradeCount _ ->
            ( model, Cmd.none )

        UpdatePerkCount _ ->
            ( model, Cmd.none )
