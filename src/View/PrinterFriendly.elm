module View.PrinterFriendly exposing (view)

import Bulma.Columns exposing (..)
import Html exposing (Html, div, hr)
import Html.Attributes exposing (style)
import Model.Model exposing (Model, Msg)
import Model.Vehicle.Model exposing (Vehicle)
import View.Vehicle exposing (renderPrint)


view : Model -> List Vehicle -> Html Msg
view model lvehicle =
    lvehicle
        |> List.map (renderPrint model)
        |> List.map (\r -> column columnModifiers [] [ r, hr [ style "border-top" "dotted 3px" ] [] ])
        |> columns columnsModifiers []
