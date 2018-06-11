module View.Upgrade exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils


render : Model -> Upgrade -> Html Msg
render model upgrade =
    let
        isPreview =
            case model.view of
                AddingUpgrade _ ->
                    True

                _ ->
                    False
    in
    div [ class "ml-4" ]
        [ h6 [] [ text upgrade.name ]
        , div [] (List.map (View.Utils.renderSpecial isPreview Nothing 0) upgrade.specials)
        ]
