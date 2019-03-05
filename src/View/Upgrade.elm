module View.Upgrade exposing (render)

import Bootstrap.Button as Btn
import Html
    exposing
        ( Html
        , br
        , div
        , h6
        , li
        , small
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
import Model.Shared exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.EquipmentLayout
import View.Utils exposing (icon, iconb)


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
            li [] [ View.Utils.renderSpecial isPreview Nothing special ]

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
            [ text <| upgrade.name
            ]
        , h6 []
            [ small [] [ text <| fromExpansion upgrade.expansion ]
            ]
        , Btn.button
            [ Btn.onClick <| DeleteUpgrade vehicle.key upgrade
            , Btn.outlineDanger
            , Btn.small
            , Btn.block
            , Btn.attrs [ classList [ ( "d-none", isPreview ) ] ]
            ]
            [ icon "trash-alt" ]
        ]
        [ factsHolder
        , specials
        ]
