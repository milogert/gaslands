module View.Upgrade exposing (RenderConfig, render)

import Bootstrap.Button as Btn
import Html
    exposing
        ( Html
        , div
        , h6
        , li
        , small
        , span
        , text
        , ul
        )
import Html.Attributes exposing (class, hidden)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.EquipmentLayout
import View.Utils exposing (icon, iconb)


type alias RenderConfig =
    { previewSpecials : Bool
    , printSpecials : Bool
    , showDeleteButton : Bool
    }


render : RenderConfig -> Model -> Vehicle -> Upgrade -> Html Msg
render cfg model vehicle upgrade =
    let
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
            li [] [ View.Utils.renderSpecial cfg.previewSpecials cfg.printSpecials Nothing Nothing special ]

        specials =
            case upgrade.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc upgrade.specials
    in
    View.EquipmentLayout.render
        upgrade
        (Just <| UpgradeMsg << DeleteUpgrade vehicle.key)
        [ factsHolder ]
        [ specials ]
