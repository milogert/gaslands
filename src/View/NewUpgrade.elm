module View.NewUpgrade exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, multiple, size)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import View.Upgrade
import View.Utils


view : Model -> Vehicle -> Html Msg
view model v =
    let
        slotsList =
            List.map .slots v.upgrades

        slotsUsed =
            List.sum slotsList

        slotsLeft =
            v.equipment - slotsUsed

        body = case model.tmpUpgrade of
            Just tmpUpgrade ->
                View.Upgrade.render tmpUpgrade

            Nothing ->
                text "Select an upgrade."
    in
    View.Utils.row
        [ View.Utils.col "md-3"
            [ button
                [ class "form-control btn btn-primary mb-3", onClick (AddUpgrade v) ]
                [ text "Add Upgrade" ]
            , select
                [ onInput TmpWeaponUpdate
                , class "form-control mb-3"
                , multiple True
                , size 8
                ]
                ( allUpgradesList
                    |> List.filter (\x -> x.slots <= slotsLeft)
                    |> List.map .name
                    |> List.map (\t -> option [ value t ] [ text t ])
                )
            ]
        , View.Utils.col "md-9" [ body ]
        ]
