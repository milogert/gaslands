module View.Settings.SquadGeneration exposing (render)

import Bootstrap.Button as Btn
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html
    exposing
        ( Html
        , div
        , h4
        , text
        )
import Html.Attributes
    exposing
        ( class
        , for
        )
import Model.Model exposing (..)
import Model.Settings exposing (..)
import View.Utils exposing (icon, iconb)


render : Settings -> Html Msg
render settings =
    Grid.row []
        [ Grid.col [ Col.xs12 ]
            [ h4 [] [ text "Squad Generation" ] ]
        , Grid.col
            [ Col.xs6
            , Col.attrs [ class "spin-fields" ]
            ]
            [ Form.group []
                [ Form.label [ for "percentVehicles" ] [ text "% Vehicles" ]
                , Input.number
                    [ Input.id "percentVehicles"
                    , Input.value <| String.fromInt settings.percentVehicles

                    -- , Input.onInput
                    , Input.placeholder "Percent of points used on vehicles"
                    ]
                ]
            , Form.group []
                [ Form.label [ for "percentWeapons" ] [ text "% Vehicles" ]
                , Input.number
                    [ Input.id "percentWeapons"
                    , Input.value <| String.fromInt settings.percentWeapons

                    -- , Input.onInput
                    , Input.placeholder "Percent of points used on weapons"
                    ]
                ]
            , Form.group []
                [ Form.label [ for "percentUpgrades" ] [ text "% Vehicles" ]
                , Input.number
                    [ Input.id "percentUpgrades"
                    , Input.value <| String.fromInt settings.percentUpgrades

                    -- , Input.onInput
                    , Input.placeholder "Percent of points used on upgrades"
                    ]
                ]
            , Form.group []
                [ Form.label [ for "percentPerks" ] [ text "% Vehicles" ]
                , Input.number
                    [ Input.id "percentPerks"
                    , Input.value <| String.fromInt settings.percentPerks

                    -- , Input.onInput
                    , Input.placeholder "Percent of points used on perks"
                    ]
                ]
            , Btn.button
                [ Btn.success
                , Btn.onClick <| SettingsMsg GenerateTeam
                ]
                [ icon "random"
                , text "Spin!"
                ]
            ]
        , Grid.col
            [ Col.xs6, Col.attrs [ class "spin-result" ] ]
            [ renderSpinResults settings.spinResults
            , Btn.button [ Btn.success ] [ icon "check", text "Accept Results" ]
            ]
        ]


renderSpinResults : List SpinResult -> Html Msg
renderSpinResults spinResults =
    spinResults
        |> List.map renderSpinResult
        |> div []


renderSpinResult : SpinResult -> Html Msg
renderSpinResult { summary, cost } =
    div []
        [ text summary
        , text <| String.fromInt cost
        ]
