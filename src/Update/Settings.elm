module Update.Settings exposing (update)

import Model.Model exposing (..)
import Model.Settings exposing (..)


update : Model -> SettingsEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        GenerateTeam ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
