module View.NewUpgrade exposing (view)

import Bootstrap.Button as Btn
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, text)
import Html.Attributes exposing (class, size, value)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import View.Upgrade
import View.Utils


view : Model -> Vehicle -> Html Msg
view model vehicle =
    let
        addButton =
            case model.tmpUpgrade of
                Just u ->
                    Btn.button
                        [ Btn.primary
                        , Btn.attrs [ class "mb-3" ]
                        , Btn.onClick (AddUpgrade vehicle.key u)
                        ]
                        [ text "Add Upgrade" ]

                Nothing ->
                    Btn.button
                        [ Btn.primary
                        , Btn.attrs [ class "mb-3" ]
                        , Btn.disabled True
                        ]
                        [ text "Select Upgrade" ]

        body =
            case model.tmpUpgrade of
                Just tmpUpgrade ->
                    View.Upgrade.render model vehicle tmpUpgrade

                Nothing ->
                    text "Select an upgrade."
    in
    Grid.row []
        [ Grid.col [ Col.md3 ]
            [ addButton
            , Select.select
                [ Select.onChange TmpUpgradeUpdate
                , Select.attrs
                    [ class "mb-3"
                    , size 8
                    ]
                ]
                (allUpgradesList
                    |> List.filter
                        (\x -> x.slots <= slotsRemaining vehicle)
                    |> List.map .name
                    |> List.map (\t -> Select.item [ value t ] [ text t ])
                )
            ]
        , Grid.col [ Col.md9 ] [ body ]
        ]
