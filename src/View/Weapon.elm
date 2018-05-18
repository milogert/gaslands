module View.Weapon exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils


render : Vehicle -> Weapon -> Html Msg
render vehicle weapon =
    let
        wtype =
            toString weapon.wtype

        range =
            toString weapon.range
    in
    div [ class "pl-4" ]
        [ h6 []
            [ text <| weapon.name ++ " "
            , small []
                [ text <| wtype ++ " - " ++ range
                , button
                    [ class "btn btn-sm btn-outline-danger float-right"
                    , onClick <| DeleteWeapon vehicle weapon ]
                    [ text "x" ]
                ]
            ]
        , p [] [ text <| "Damage: " ++ View.Utils.renderDice weapon.attack ]
        , ul [] <| List.map (\s -> li [] [ View.Utils.renderSpecial s ]) weapon.specials
        ]
