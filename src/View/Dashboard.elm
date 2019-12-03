module View.Dashboard exposing (view)

import Bulma.Modifiers exposing (..)
import Bulma.Layout exposing (..)


import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Modal as Modal
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)
import View.Vehicle
import Model.Utils exposing (..)

view : Model -> Html Msg
view model =
    let
        isWrecked v =
            v.hull.current >= totalHull v

        available = model.vehicles
            |> Dict.values
            |> List.filter (\v -> not (v.activated || isWrecked v))

        unavailable = model.vehicles
            |> Dict.values
            |> List.filter (\v -> v.activated || isWrecked v)
    in
    container []
        [ div
            [ class "vehicles-available" ]
            (available
                |> List.map (View.Vehicle.renderCard model))
        , div
            [ class "vehicles-unavilabled" ]
            (unavailable
                |> List.map (View.Vehicle.renderCard model))
        ]

