module View.NewVehicle exposing (addButton, view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Html exposing (Html, div, hr, option, text)
import Html.Attributes
    exposing
        ( class
        , disabled
        , placeholder
        , size
        , value
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Utils
import View.Vehicle


view : Model -> Html Msg
view model =
    let
        body =
            case model.tmpVehicle of
                Just v ->
                    View.Vehicle.renderPreview model v

                Nothing ->
                    text "Select a vehicle type."

        options =
            allVehicles
                |> List.filter (View.Utils.vehicleSponsorFilter model)
                |> List.indexedMap vehicleOption
                |> (::) (option [ value "-1" ] [ text "Select Vehicle" ])

        selectList =
            controlSelect
                controlSelectModifiers
                []
                [ onInput <| VehicleMsg << TmpVehicleType
                , class "mb-3"
                ]
                options

        nameInput =
            case model.tmpVehicle of
                Nothing ->
                    controlText
                        { controlInputModifiers | disabled = True }
                        []
                        [ placeholder "Select a vehicle type above"
                        , disabled True
                        ]
                        []

                Just vehicle ->
                    controlText
                        controlInputModifiers
                        []
                        [ placeholder "Name"
                        , onInput <| VehicleMsg << TmpName
                        , value vehicle.name
                        ]
                        []
    in
    div []
        [ field []
            [ controlLabel []
                [ text "Vehicle Type" ]
            , selectList
            ]
        , field []
            [ controlLabel []
                [ text "Vehicle Name" ]
            , nameInput
            ]
        , div [] [ body ]
        , addButton model.tmpVehicle
        ]


vehicleOption : Int -> Vehicle -> Html Msg
vehicleOption i vt =
    option
        [ value <| String.fromInt i ]
        [ text <| fromVehicleType vt.vtype ]


addButton : Maybe Vehicle -> Html Msg
addButton tmpVehicle =
    let
        disabledButton =
            case tmpVehicle of
                Just vehicle ->
                    case vehicle.name of
                        "" ->
                            True

                        _ ->
                            False

                Nothing ->
                    True

        event =
            case tmpVehicle of
                Nothing ->
                    []

                Just v ->
                    [ onClick <| VehicleMsg (AddVehicle v) ]

        attrs =
            List.append
                event
                []

        buttonText =
            case tmpVehicle of
                Just vehicle ->
                    case vehicle.name of
                        "" ->
                            "Input Name"

                        _ ->
                            "Add " ++ vehicle.name

                Nothing ->
                    "Select Vehicle"
    in
    controlButton
        { buttonModifiers | disabled = disabledButton }
        []
        attrs
        [ text buttonText ]
