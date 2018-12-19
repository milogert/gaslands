module View.Details exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Utils
import View.Vehicle


view : Model -> Vehicle -> Html Msg
view model v =
    Grid.row []
        [ Grid.col [ Col.xs12 ]
            [ View.Vehicle.render model (Details v) v ]
        ]
