module View.NewVehicle exposing (addButton, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing
import Html exposing (Html, hr, text)
import Html.Attributes
    exposing
        ( class
        , disabled
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
                |> (::) (Select.item [ value "-1" ] [ text "Select Vehicle" ])

        selectList =
            Select.select
                [ Select.onChange <| VehicleMsg << TmpVehicleType
                , Select.attrs [ class "mb-3" ]
                ]
                options

        nameInput =
            case model.tmpVehicle of
                Nothing ->
                    Input.text
                        [ Input.placeholder "Select a vehicle type above"
                        , Input.attrs [ disabled True, Spacing.mr1 ]
                        ]

                Just vehicle ->
                    Input.text
                        [ Input.placeholder "Name"
                        , Input.onInput <| VehicleMsg << TmpName
                        , Input.value vehicle.name
                        , Input.attrs [ Spacing.mr1 ]
                        ]
    in
    Grid.row []
        [ Grid.col [ Col.md12 ]
            [ Form.form []
                [ Form.row []
                    [ Form.colLabel [ Col.mdAuto ]
                        [ Form.label [] [ text "Vehicle Type" ] ]
                    , Form.col [] [ selectList ]
                    ]
                , Form.row []
                    [ Form.colLabel [ Col.mdAuto ]
                        [ Form.label [] [ text "Vehicle Name" ] ]
                    , Form.col [] [ nameInput ]
                    ]
                ]
            ]
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
