module View.Upgrade exposing (render)

import Html
    exposing
        ( Html
        , button
        , div
        , h6
        , li
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( class
        , classList
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import View.EquipmentLayout
import View.Utils


render : Model -> Vehicle -> Upgrade -> Html Msg
render model vehicle upgrade =
    let
        isPreview =
            case model.view of
                ViewAddingUpgrade _ ->
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
                [ text <| String.fromInt upgrade.slots ++ " " ++ slotLabel ++ " used" ]

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
                [ text <| String.fromInt upgrade.cost ++ " " ++ pointLabel ]

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
    View.EquipmentLayout.render
        (not isPreview)
        [ h6
            [ classList [ ( "form-inline", isPreview ) ] ]
            [ text <| upgrade.name ++ " "
            ]
        , button
            [ class "btn btn-sm btn-link"
            , classList [ ( "d-none", isPreview ) ]
            , onClick <| DeleteUpgrade vehicle upgrade
            ]
            [ text "Remove Upgrade" ]
        ]
        [ factsHolder
        , specials
        ]
