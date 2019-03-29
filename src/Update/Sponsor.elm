module Update.Sponsor exposing (set)

import Dict
import Model.Model exposing (Model, Msg)
import Model.Sponsors exposing (Sponsor)


set : Model -> Maybe Sponsor -> ( Model, Cmd Msg )
set model s =
    ( { model
        | sponsor = s
        , vehicles = Dict.map (\k v -> { v | perks = [] }) model.vehicles
      }
    , Cmd.none
    )
