module View.Upgrade exposing (RenderConfig, render)

import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html
    exposing
        ( Html
        , div
        , text
        )
import Html.Attributes exposing (class, classList)
import Model.Model exposing (Model, Msg(..))
import Model.Upgrade exposing (Upgrade, UpgradeEvent(..))
import Model.Vehicle exposing (Vehicle)
import View.EquipmentLayout
import View.Utils exposing (plural, tagGen)


type alias RenderConfig =
    { previewSpecials : Bool
    , printSpecials : Bool
    , showDeleteButton : Bool
    , highlightRow : Bool
    }


render : RenderConfig -> Model -> Vehicle -> Upgrade -> Html Msg
render cfg model vehicle upgrade =
    let
        slotsTakenBadge =
            ( "slot" ++ plural upgrade.slots ++ " used", Just <| String.fromInt upgrade.slots )

        pointBadge =
            ( "point" ++ plural upgrade.cost, Just <| String.fromInt upgrade.cost )

        factsHolder =
            [ slotsTakenBadge
            , pointBadge
            ]
                |> List.map (\( title, value ) -> tagGen ( title, Bulma.Modifiers.Light ) ( value, Info ))
                |> List.map (\t -> control controlModifiers [] [ t ])
                |> multilineFields
                    []

        renderSpecialsFunc specialList =
            specialList
                |> List.map
                    (View.Utils.specialToHeaderBody
                        cfg.previewSpecials
                        cfg.printSpecials
                        Nothing
                        Nothing
                    )
                |> List.map View.Utils.renderSpecialRow

        specials =
            case upgrade.specials of
                [] ->
                    text <| "No special rules."

                _ ->
                    div [] <| renderSpecialsFunc upgrade.specials
    in
    View.EquipmentLayout.render
        [ class "upgrade", classList [ ( "alternate", cfg.highlightRow ) ] ]
        upgrade
        (Just <| UpgradeMsg << DeleteUpgrade vehicle.key)
        [ factsHolder ]
        [ specials ]
