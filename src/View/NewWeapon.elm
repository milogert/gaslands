module View.NewWeapon exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, multiple, size)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils
import View.Weapon


view : Model -> Vehicle -> Html Msg
view model v =
    let
        slotsList =
            List.map .slots v.weapons

        slotsUsed =
            List.sum slotsList

        slotsLeft =
            v.equipment - slotsUsed

        crewLeft =
            v.crew - View.Utils.crewUsed v

        isCrewFree =
            crewLeft > 0

        addButton =
            case (model.tmpWeapon) of
                (Just w) ->
                    button
                        [ class "form-control btn btn-primary mb-3"
                        , onClick (AddWeapon v w)
                        ]
                        [ text "Add Weapon" ]

                (Nothing) ->
                    button
                        [ class "form-control btn btn-primary mb-3"
                        , disabled True
                        ]
                        [ text "Select Weapon" ]

        body =
            case model.tmpWeapon of
                Just tmpWeapon ->
                    View.Weapon.render model v tmpWeapon

                Nothing ->
                    text "Select a weapon."
    in
        View.Utils.row
            [ View.Utils.col "md-3"
                [ addButton
                , select
                    [ onInput TmpWeaponUpdate
                    , class "form-control mb-3"
                    , multiple True
                    , size 8
                    ]
                    (allWeaponsList
                        |> List.filter (\x -> x.slots <= slotsLeft)
                        |> List.filter (\x -> x.name /= handgun.name)
                        |> List.map .name
                        |> List.map (\t -> option [ value t ] [ text t ])
                    )
                ]
            , View.Utils.col "md-9" [ body ]
            ]
