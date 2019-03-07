module Update.Sponsor exposing (set)

import Model.Model exposing (Model, Msg)
import Model.Sponsors exposing (Sponsor)


set : Model -> Maybe Sponsor -> ( Model, Cmd Msg )
set model s =
    ( { model | sponsor = s }
    , Cmd.none
    )
