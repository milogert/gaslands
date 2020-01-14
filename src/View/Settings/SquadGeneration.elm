module View.Settings.SquadGeneration exposing (render)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import FontAwesome.Icon as Icon
import FontAwesome.Solid as Icon
import Html
    exposing
        ( Html
        , div
        , h4
        , text
        )
import Model.Model exposing (..)
import Model.Settings exposing (..)


render : Settings -> Html Msg
render settings =
    columns columnsModifiers
        []
        [ column columnModifiers
            []
            [ h4 [] [ text "Squad Generation" ]

            {- , Form.group []
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
               , button buttonModifiers
                   [ onClick <| SettingsMsg GenerateTeam ]
                   [ Icon.viewIcon Icon.random
                   , text "Spin!"
                   ]
                   ]
            -}
            ]
        , column columnModifiers
            []
            [ renderSpinResults settings.spinResults
            , button buttonModifiers
                []
                [ Icon.viewIcon Icon.check, text "Accept Results" ]
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
