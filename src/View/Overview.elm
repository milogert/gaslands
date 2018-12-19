module View.Overview exposing (view)

import Html exposing (Html, a, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)
import View.Vehicle


view : Model -> Html Msg
view model =
    View.Utils.row
        [ View.Utils.col "12"
            [ div
                [ class "card-columns" ]
                (List.map (View.Vehicle.render model model.view) model.vehicles)
            ]
        , View.Utils.col "12"
            [ button
                [ onClick ToNewVehicle
                , class "btn btn-primary btn-block mb-3"
                ]
                [ icon "plus", text "New Vehicle" ]
            ]
        ]
