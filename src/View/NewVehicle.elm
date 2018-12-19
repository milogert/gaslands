module View.NewVehicle exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, multiple, placeholder, rel, size, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Utils
import View.Vehicle


view : Model -> Html Msg
view model =
    let
        body =
            case model.tmpVehicle of
                Just v ->
                    View.Vehicle.renderPreview model model.view v

                Nothing ->
                    text "Select a vehicle type."

        disabledButton =
            case model.tmpVehicle of
                Just tmpVehicle ->
                    case tmpVehicle.name of
                        "" ->
                            True

                        _ ->
                            False

                Nothing ->
                    True

        buttonText =
            case model.tmpVehicle of
                Just tmpVehicle ->
                    case tmpVehicle.name of
                        "" ->
                            "Input Name"

                        _ ->
                            "Add " ++ tmpVehicle.name

                Nothing ->
                    "Select Vehicle"

        addButton =
            button
                [ onClick AddVehicle
                , class "btn btn-primary btn-block mb-3"
                , disabled disabledButton
                ]
                [ text buttonText ]

        options =
            allVehicleTypes
                |> List.filter (View.Utils.vehicleSponsorFilter model)
                |> List.map vehicleOption

        selectList =
            select
                [ onInput TmpVehicleType
                , class "form-control mb-3"
                , size 8
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md3 ]
            [ addButton
            , selectList
            ]
        , Grid.col [ Col.md9 ] [ body ]
        ]


vehicleOption : VehicleType -> Html Msg
vehicleOption vt =
    option [ value <| fromVehicleType vt ] [ text <| fromVehicleType vt ]
