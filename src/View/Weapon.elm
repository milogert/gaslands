module View.Weapon exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils


render : CurrentView -> Vehicle -> Weapon -> Html Msg
render view vehicle weapon =
    let
        isPreview =
            case view of
                AddingWeapon _ ->
                    True

                _ ->
                    False

        wtype =
            toString weapon.wtype

        range =
            toString weapon.range

        firingToggle =
            case weapon.status of
                WeaponReady ->
                    SetWeaponFired vehicle weapon

                WeaponFired ->
                    SetWeaponFired vehicle weapon

        crewAvailable =
            View.Utils.crewUsed vehicle < vehicle.crew

        canFire =
            case (weapon.status, crewAvailable) of
                (WeaponReady, True) ->
                    True

                (WeaponFired, False) ->
                    False

                (_, _) ->
                    False

        firingText =
            case weapon.status of
                WeaponReady ->
                    "Fire"

                WeaponFired ->
                    "Fired"

        fireButton =
            button
                [ class "btn btn-sm mr-2"
                , classList
                    [ ( "btn-secondary", weapon.status == WeaponFired )
                    , ( "btn-primary", weapon.status == WeaponReady )
                    , ( "d-none", isPreview )
                    ]
                , disabled <| not canFire
                , onClick firingToggle
                ]
                [ text firingText ]
            
        mountPointId =
            "mountPoint-" ++ (toString weapon.id)

        mountPoint =
            case (weapon.mountPoint, isPreview) of
                (Just point, False) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text <| mountPointToString point ]

                (_, True) ->
                    div [ class "mr-2" ]
                        [ select
                            [ class "form-control form-control-sm"
                            , onInput TmpWeaponMountPoint
                            , id mountPointId
                            ]
                            ((option [ value "" ] [ text "" ]) ::
                            (List.map
                                (\m -> option
                                    [ value <| mountPointToString m ]
                                    [ text <| mountPointToString m ]
                                )
                                [ Full, Front, LeftSide, RightSide, Rear ]
                            ))
                        ]

                (Nothing, False) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text "No mount point" ]

        specials =
            case weapon.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map (\s -> li [] [ View.Utils.renderSpecial s ]) weapon.specials
                    
    in
        div [ class "pl-4" ]
            [ h6
                [ classList [ ("form-inline", isPreview) ] ]
                [ mountPoint
                , text <| weapon.name ++ " "
                , small [ class "ml-2" ]
                    [ text <| wtype ++ " - " ++ range
                    ]
                ]
            , div []
                [ fireButton
                , text <| "Damage: " ++ View.Utils.renderDice weapon.attack
                ]
            , specials
            , button
                [ class "btn btn-sm btn-link"
                , classList [ ("d-none", isPreview) ]
                , onClick <| DeleteWeapon vehicle weapon
                ]
                [ text "Remove Weapon" ]
            ]
