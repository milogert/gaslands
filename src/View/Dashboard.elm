module View.Dashboard exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Modal as Modal
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Utils exposing (icon)
import View.Vehicle


view : Model -> Html Msg
view model =
    Grid.simpleRow
        [ Grid.col [ Col.xs ]
            [ Button.button
                [ Button.primary
                , Button.block
                , Button.onClick <| ShowModal "vehicle"
                , Button.attrs [ class "mb-3" ]
                ]
                [ icon "plus", icon "car" ]
            ]
        , Grid.col [ Col.xsAuto ]
            [ Button.button
                [ Button.roleLink
                , Button.block
                , Button.onClick <| To <| ViewPrinterFriendly <| Dict.values model.vehicles
                ]
                [ icon "print", text "All Vehicles" ]
            ]
        , Grid.col [ Col.xs12 ]
            [ model.vehicles
                |> Dict.values
                |> List.map (View.Vehicle.renderCard model)
                |> Card.columns
            ]
        ]
