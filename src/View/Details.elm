module View.Details exposing (view)

import Html exposing (Html)
import Model.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Vehicle


view : Model -> Vehicle -> Html Msg
view model v =
    View.Vehicle.renderDetails model v
