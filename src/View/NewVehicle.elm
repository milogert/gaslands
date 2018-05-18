module View.NewVehicle exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Vehicle


view : Model -> Html Msg
view model =
    let
        body = case model.tmpVehicle of
            Just v ->
                View.Vehicle.render model.view True v

            Nothing ->
                text "Select a vehicle type."
    in
    div []
        [ body
        , button
            [ onClick AddVehicle
            , class "btn btn-primary btn-block mt-3"
            ]
            [ text "Add Vehicle" ]
        ]
