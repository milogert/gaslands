module View.EquipmentLayout exposing (render)

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
    View.Utils.row
        [ View.Utils.colPlus [ "md-3 sm-12" ] [ displayNone ] left
        , View.Utils.col "" right
        ]
