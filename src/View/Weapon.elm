module View.Weapon exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.Utils exposing (icon)
import View.EquipmentLayout


render : Model -> Vehicle -> Weapon -> Html Msg
render model vehicle weapon =
    let
        isPreview =
            case model.view of
                AddingWeapon _ ->
                    True

                _ ->
                    False

        firingToggle =
            case weapon.status of
                WeaponReady ->
                    SetWeaponFired vehicle weapon

                WeaponFired ->
                    SetWeaponFired vehicle weapon

        crewAvailable =
            View.Utils.crewUsed vehicle < vehicle.crew

        canFire =
            case ( weapon.status, crewAvailable ) of
                ( WeaponReady, True ) ->
                    True

                ( WeaponFired, False ) ->
                    False

                ( _, _ ) ->
                    False

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
                [ icon "crosshairs"
                , span [ classList [ ( "d-none", weapon.attack == Nothing ) ] ]
                    [ text <| View.Utils.renderDice weapon.attack ]
                ]

        previewDamage =
            span
                [ class "badge badge-secondary mr-2"
                , classList [ ( "d-none", weapon.attack == Nothing ) ]
                ]
                [ text <| View.Utils.renderDice weapon.attack ++ " damage" ]

        mountPointId =
            "mountPoint-" ++ (toString weapon.id)

        mountPoint =
            case ( weapon.mountPoint, isPreview ) of
                ( Just CrewFired, _ ) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text <| mountPointToString CrewFired ]

                ( Just point, False ) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text <| mountPointToString point ]

                ( _, True ) ->
                    div [ class "mr-2" ]
                        [ select
                            [ class "form-control form-control-sm"
                            , onInput TmpWeaponMountPoint
                            , id mountPointId
                            ]
                            ((option [ value "" ] [ text "" ])
                                :: (List.map
                                        (\m ->
                                            option
                                                [ value <| mountPointToString m ]
                                                [ text <| mountPointToString m ]
                                        )
                                        [ Full, Front, LeftSide, RightSide, Rear ]
                                   )
                            )
                        ]

                ( Nothing, False ) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text "No mount point" ]

        slotsTakenBadge =
            let
                slotLabel =
                    case weapon.slots of
                        1 ->
                            "slot"

                        _ ->
                            "slots"
            in
                span [ class "badge badge-secondary mr-2" ]
                    [ text <| toString weapon.slots ++ " " ++ slotLabel ++ " used" ]

        typeBadge =
            span [ class "badge badge-secondary mr-2" ]
                [ text <| toString weapon.wtype ++ " type" ]

        rangeBadge =
            span [ class "badge badge-secondary mr-2" ]
                [ text <| toString weapon.range ++ " range" ]

        pointBadge =
            let
                finalCost =
                    weaponCost weapon

                pointLabel =
                    case finalCost of
                        1 ->
                            "point"

                        _ ->
                            "points"
            in
                span [ class "badge badge-secondary mr-2" ]
                    [ text <| toString finalCost ++ " " ++ pointLabel ]

        factsHolder =
            div [ class "mb-2" ]
                [ mountPoint
                , slotsTakenBadge
                , previewDamage
                , typeBadge
                , rangeBadge
                , pointBadge
                ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial isPreview (Just <| UpdateAmmoUsed vehicle weapon) weapon.ammoUsed special ]

        specials =
            case weapon.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc weapon.specials
    in
        View.EquipmentLayout.render
            (not isPreview)
            [ View.Utils.row
                [ div
                    [ class "col-md-12 col" ]
                    [ h6 [] [ text <| weapon.name ++ " " ] ]
                , div [ class "col-md-12 col" ] [ fireButton ]
                , div [ class "col-md-12 col" ]
                    [ button
                        [ class "btn btn-sm btn-danger"
                        , classList [ ( "d-none", isPreview ) ]
                        , onClick <| DeleteWeapon vehicle weapon
                        ]
                        [ icon "trash-alt" ]
                    ]
                ]
            ]
            [ factsHolder, specials ]
