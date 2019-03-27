module View.Details exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html)
import Model.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Vehicle


view : Model -> Vehicle -> Html Msg
view model v =
    Grid.row []
        [ Grid.col [ Col.xs12 ]
            [ View.Vehicle.renderDetails model v ]
        ]
