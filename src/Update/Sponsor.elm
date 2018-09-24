module Update.Sponsor exposing (set)

import Model.Model exposing (Model, Msg)
import Model.Sponsors exposing (SponsorType)


set : Model -> Maybe SponsorType -> ( Model, Cmd Msg )
set model s =
    { model | sponsor = s } ! []
