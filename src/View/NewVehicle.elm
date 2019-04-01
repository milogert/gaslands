module View.NewVehicle exposing (addButton, view)

import Bootstrap.Button as Button
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, hr, text)
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
                    View.Vehicle.renderPreview model v

                Nothing ->
                    text "Select a vehicle type."

        options =
            allVehicles
                |> List.filter (View.Utils.vehicleSponsorFilter model)
                |> List.indexedMap vehicleOption
                |> (::) (Select.item [] [ text "Select Vehicle" ])

        selectList =
            Select.select
                [ Select.onChange <| VehicleMsg << TmpVehicleType
                , Select.attrs [ class "mb-3" ]
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md12 ] [ selectList ]
        , Grid.col [ Col.md12 ] [ hr [] [] ]
        , Grid.col [ Col.md12 ] [ body ]
        ]


vehicleOption : Int -> Vehicle -> Select.Item Msg
vehicleOption i vt =
    Select.item
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
                    [ Button.onClick <| VehicleMsg (AddVehicle v) ]

        attrs =
            List.append
                event
                [ Button.primary

                --, Button.block
                , Button.attrs [ class "mb-3" ]
                , Button.disabled disabledButton
                ]

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
    Button.button
        attrs
        [ text buttonText ]
