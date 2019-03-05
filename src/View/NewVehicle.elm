module View.NewVehicle exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, text)
import Html.Attributes
    exposing
        ( class
        , size
        , value
        )
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
            let
                event =
                    case model.tmpVehicle of
                        Nothing ->
                            []

                        Just v ->
                            [ Button.onClick <| VehicleMsg (AddVehicle v) ]

                attrs =
                    List.append
                        event
                        [ Button.primary
                        , Button.block
                        , Button.attrs [ class "mb-3" ]
                        , Button.disabled disabledButton
                        ]
            in
            Button.button
                attrs
                [ text buttonText ]

        options =
            allVehicles
                |> List.filter (View.Utils.vehicleSponsorFilter model)
                |> List.indexedMap vehicleOption

        selectList =
            Select.select
                [ Select.onChange <| VehicleMsg << TmpVehicleType
                , Select.attrs
                    [ class "mb-3"
                    , size 8
                    ]
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md3 ] [ addButton, selectList ]
        , Grid.col [ Col.md9 ] [ body ]
        ]


vehicleOption : Int -> Vehicle -> Select.Item Msg
vehicleOption i vt =
    Select.item
        [ value <| String.fromInt i ]
        [ text <| fromVehicleType vt.vtype ]
