module View.NewUpgrade exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
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
            v.gear - slotsUsed
    in
    div []
        [ select
            [ onInput TmpUpgradeUpdate
            , class "form-control"
            ]
            (option [] []
                :: (List.filter (\x -> x.slots <= slotsLeft) allUpgradesList
                        |> List.map .name
                        |> List.map (\t -> option [ value t ] [ text t ])
                   )
            )
        , View.Upgrade.render model.tmpUpgrade
        , button [ class "form-control btn btn-primary", onClick (AddUpgrade v) ] [ text "Add Upgrade" ]
        ]
