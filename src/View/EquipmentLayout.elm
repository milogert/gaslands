module View.EquipmentLayout exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html)
import Model.Model exposing (..)
import View.Utils


render : Bool -> List (Html Msg) -> List (Html Msg) -> Html Msg
render shouldShowSidebar left right =
    let
        displayNone =
            if shouldShowSidebar then
                ""

            else
                "d-none"
    in
    Grid.row [ Row.middleXs, Row.topMd ]
        [ Grid.col [ Col.md3 ] left
        , Grid.col [ Col.md9 ] right
        ]
