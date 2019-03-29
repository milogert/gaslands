module View.PrinterFriendly exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, div, hr)
import Html.Attributes exposing (style)
import Model.Model exposing (Model, Msg)
import Model.Vehicle.Model exposing (Vehicle)
import View.Vehicle exposing (renderPrint)


view : Model -> List Vehicle -> Html Msg
view model lvehicle =
    lvehicle
        |> List.map (renderPrint model)
        |> List.map (\r -> Grid.col [ Col.md6 ] [ r, hr [ style "border-top" "dotted 3px" ] [] ])
        |> Grid.simpleRow
