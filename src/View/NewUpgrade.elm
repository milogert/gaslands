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
        addButton =
            case (model.tmpUpgrade) of
                Just u ->
                    button
                        [ class "form-control btn btn-primary mb-3"
                        , onClick (AddUpgrade v u)
                        ]
                        [ text "Add Upgrade" ]

                Nothing ->
                    button
                        [ class "form-control btn btn-primary mb-3"
                        , disabled True
                        ]
                        [ text "Select Upgrade" ]

        body =
            case model.tmpUpgrade of
                Just tmpUpgrade ->
                    View.Upgrade.render model v tmpUpgrade

                Nothing ->
                    text "Select an upgrade."
    in
        View.Utils.row
            [ View.Utils.col "md-3"
                [ addButton
                , select
                    [ onInput TmpUpgradeUpdate
                    , class "form-control mb-3"
                    , multiple True
                    , size 8
                    ]
                    (allUpgradesList
                        |> List.filter
                            (\x -> x.slots <= (slotsRemaining v))
                        |> List.map .name
                        |> List.map (\t -> option [ value t ] [ text t ])
                    )
                ]
            , View.Utils.col "md-9" [ body ]
            ]
