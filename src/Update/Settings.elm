module Update.Settings exposing (update)

import List.Extra as ListE
import Model.Model exposing (..)
import Model.Settings exposing (..)


update : Model -> SettingsEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        EnableExpansion expansion isEnabled ->
            let
                settings =
                    model.settings

                expansions =
                    settings.expansions

                enabled =
                    expansions.enabled

                newEnabled =
                    case isEnabled of
                        True ->
                            expansion :: enabled

                        False ->
                            ListE.remove expansion enabled

                newSettings =
                    { settings | expansions = { expansions | enabled = newEnabled } }
            in
            ( { model | settings = newSettings }
            , Cmd.none
            )

        GenerateTeam ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
