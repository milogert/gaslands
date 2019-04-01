module View.EquipmentLayout exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html)
import Model.Model exposing (..)
import View.Utils


render : List (Html Msg) -> List (Html Msg) -> Html Msg
render left right =
    Grid.row [ Row.middleXs, Row.topMd ]
        [ Grid.col [ Col.md3 ] left
        , Grid.col [ Col.md9 ] right
        ]
