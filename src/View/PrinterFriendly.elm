module View.PrinterFriendly exposing (view)

import Html exposing (Html, text)
import Model.Model exposing (Model, Msg)
import Model.Vehicle.Model exposing (Vehicle)
import View.Vehicle exposing (renderPrint)


view : Model -> Vehicle -> Html Msg
view model vehicle =
    renderPrint model vehicle
