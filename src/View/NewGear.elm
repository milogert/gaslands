module View.NewWeapon exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils


view : Model -> Int -> Vehicle -> Html Msg
view model i v =
    let
        slotsList =
            List.map .slots v.weapons

        slotsUsed =
            List.sum slotsList

        slotsLeft =
            v.gear - slotsUsed

        crewLeft =
            v.crew - View.Utils.crewUsed v

        isCrewFree =
            crewLeft > 0
    in
        div []
            [ select
                [ onInput TmpWeaponUpdate
                , class "form-control"
                ]
                (option [] []
                    :: (List.filter (\x -> x.slots <= slotsLeft) weapons
                            |> List.filter
                                (\x ->
                                    (not <| List.member CrewFired x.specials)
                                        || (isCrewFree && List.member CrewFired x.specials)
                                )
                            |> List.map .name
                            |> List.map (\t -> option [ value t ] [ text t ])
                       )
                )
            , View.Utils.renderWeapon model.tmpWeapon
            , button [ class "form-control btn btn-primary", onClick (AddWeapon i v) ] [ text "Add Weapon" ]
            ]
