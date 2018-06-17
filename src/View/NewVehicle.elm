module View.NewVehicle exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, multiple, size)
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
                    View.Vehicle.render model model.view True v

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
    in
        View.Utils.row
            [ View.Utils.col "md-3"
                [ button
                    [ onClick AddVehicle
                    , class "btn btn-primary btn-block mb-3"
                    , disabled disabledButton
                    ]
                    [ text buttonText ]
                , select
                    [ onInput TmpVehicleType
                    , class "form-control"
                    , multiple True
                    , size 8
                    ]
                    (List.map
                        (\x -> option [ value <| vTToStr x ] [ text <| vTToStr x ])
                        allVehicleTypes
                    )
                ]
            , View.Utils.col "md-9" [ body ]
            ]
