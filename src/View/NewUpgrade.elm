module View.NewUpgrade exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, div, hr, text)
import Html.Attributes exposing (class, disabled, size, value)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Upgrade


view : Model -> Vehicle -> List Upgrade -> Html Msg
view model vehicle weapons =
    let
        buttonAttrs =
            [ Button.primary
            , Button.attrs [ class "mb-3" ]
            ]

        addButton =
            case model.tmpUpgrade of
                Just upgrade ->
                    Button.button
                        (Button.onClick (UpgradeMsg <| AddUpgrade vehicle.key upgrade) :: buttonAttrs)
                        [ text <| "Add " ++ upgrade.name ++ " to " ++ vehicle.name ]

                Nothing ->
                    Button.button
                        (Button.disabled True :: buttonAttrs)
                        [ text "Choose Upgrade Type" ]

        body =
            case model.tmpUpgrade of
                Just weapon ->
                    View.Upgrade.render
                        (View.Upgrade.RenderConfig
                            True
                            False
                            False
                        )
                        model
                        vehicle
                        weapon

                Nothing ->
                    text "Select an upgrade type from the dropdown."

        thingToTuple : Upgrade -> ( String, String )
        thingToTuple t =
            ( t.name, fromExpansionAbbrev t.expansion )

        options =
            weapons
                |> List.map thingToTuple
                |> List.map
                    (\( name, exp ) ->
                        Select.item
                            [ value name ]
                            [ text <| name ++ " (" ++ exp ++ ")" ]
                    )
                |> (::) (Select.item [] [ text "" ])

        selectList =
            Select.select
                [ Select.onChange (UpgradeMsg << TmpUpgradeUpdate)
                , Select.attrs
                    [ class "mb-3"
                    ]
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md12 ]
            [ Form.form []
                [ Form.row []
                    [ Form.colLabel [ Col.mdAuto ]
                        [ Form.label [] [ text "Upgrade Type" ] ]
                    , Form.col [] [ selectList ]
                    ]
                ]
            ]
        , Grid.col [ Col.md12 ] [ addButton ]
        , Grid.col [ Col.md12 ] [ body ]
        ]
