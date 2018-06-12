module View.Upgrade exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import View.Utils


render : Model -> Vehicle -> Upgrade -> Html Msg
render model vehicle upgrade =
    let
        isPreview =
            case model.view of
                AddingUpgrade _ ->
                    True

                _ ->
                    False

        slotsTakenBadge =
            let
                slotLabel =
                    case upgrade.slots of
                        1 ->
                            "slot"

                        _ ->
                            "slots"
            in
                span [ class "badge badge-secondary mr-2" ]
                    [ text <| toString upgrade.slots ++ " " ++ slotLabel ++ " used" ]

        pointBadge =
            let
                pointLabel =
                    case upgrade.cost of
                        1 ->
                            "point"

                        _ ->
                            "points"
            in
                span [ class "badge badge-secondary mr-2" ]
                    [ text <| toString upgrade.cost ++ " " ++ pointLabel ]

        factsHolder =
            div []
                [ slotsTakenBadge
                , pointBadge
                ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial isPreview Nothing 0 special ]

        specials =
            case upgrade.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc upgrade.specials
    in
        div [ class "pl-4" ]
            [ h6
                [ classList [ ( "form-inline", isPreview ) ] ]
                [ text <| upgrade.name ++ " "
                , button
                    [ class "btn btn-sm btn-link"
                    , classList [ ( "d-none", isPreview ) ]
                    , onClick <| DeleteUpgrade vehicle upgrade
                    ]
                    [ text "Remove Upgrade" ]
                ]
            , factsHolder
            , specials
            ]



--, div [] (List.map (View.Utils.renderSpecial isPreview Nothing 0) upgrade.specials)
--]
