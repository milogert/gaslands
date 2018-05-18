module View.Details exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Utils
import View.Vehicle


view : Vehicle -> Html Msg
view v =
    View.Utils.row
        [ View.Utils.col "12"
            [ div []
                [ View.Vehicle.render (Details v) False v ]
            ]
        ]
