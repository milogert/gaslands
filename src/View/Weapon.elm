module View.Weapon exposing (render)

import Bootstrap.Button as Btn
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html
    exposing
        ( Html
        , div
        , h6
        , li
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( class
        , classList
        , disabled
        , value
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared
import Model.Utils exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import View.EquipmentLayout
import View.Utils exposing (icon)


render : Model -> Vehicle -> Weapon -> Html Msg
render model vehicle weapon =
    let
        isPreview =
            case model.view of
                ViewAddingWeapon _ ->
                    True

                _ ->
                    False

        firingToggle =
            case weapon.status of
                WeaponReady ->
                    SetWeaponFired vehicle.key weapon

                WeaponFired ->
                    SetWeaponFired vehicle.key weapon

        crewAvailable =
            View.Utils.crewUsed vehicle < totalCrew vehicle

        canFire =
            case ( weapon.status, crewAvailable ) of
                ( WeaponReady, True ) ->
                    True

                ( WeaponFired, False ) ->
                    False

                ( _, _ ) ->
                    False

        attackResult =
            case weapon.attackRoll of
                0 ->
                    text ""

                i ->
                    text <| " (rolled " ++ String.fromInt i ++ ")"

        fireButton =
            Btn.button
                [ Btn.small
                , Btn.block
                , Btn.disabled <| not canFire
                , Btn.onClick firingToggle
                , Btn.attrs
                    [ class "mr-2"
                    , classList
                        [ ( "btn-secondary", weapon.status == WeaponFired )
                        , ( "btn-primary", weapon.status == WeaponReady )
                        , ( "d-none", isPreview )
                        ]
                    ]
                ]
                [ icon "crosshairs"
                , span [ classList [ ( "d-none", weapon.attack == Nothing ) ] ]
                    [ text <| View.Utils.renderDice weapon.attack
                    , attackResult
                    ]
                ]

        previewDamage =
            span
                [ class "badge badge-secondary mr-2"
                , classList [ ( "d-none", weapon.attack == Nothing ) ]
                ]
                [ text <| View.Utils.renderDice weapon.attack ++ " damage" ]

        mountPointId =
            "mountPoint-" ++ String.fromInt weapon.id

        mountPoint =
            case ( weapon.mountPoint, isPreview ) of
                ( Just CrewFired, _ ) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text <| fromWeaponMounting CrewFired ]

                ( Just point, False ) ->
                    span [ class "badge badge-secondary mr-2" ]
                        [ text <| fromWeaponMounting point ]

                ( _, True ) ->
                    div [ class "mr-2" ]
                        [ Select.select
                            [ Select.small
                            , Select.onChange TmpWeaponMountPoint
                            , Select.id mountPointId
                            ]
                            (Select.item [ value "" ] [ text "" ]
                                :: List.map
                                    (\m ->
                                        Select.item
                                            [ value <| fromWeaponMounting m ]
                                            [ text <| fromWeaponMounting m ]
                                    )
                                    [ Full, Front, LeftSide, RightSide, Rear ]
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
                [ text <| String.fromInt weapon.slots ++ " " ++ slotLabel ++ " used" ]

        typeBadge =
            span [ class "badge badge-secondary mr-2" ]
                [ text <| fromWeaponType weapon.wtype ++ " type" ]

        rangeBadge =
            span [ class "badge badge-secondary mr-2" ]
                [ text <| fromWeaponRange weapon.range ++ " range" ]

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
                [ text <| String.fromInt finalCost ++ " " ++ pointLabel ]

        factsHolder =
            View.Utils.factsHolder
                [ mountPoint
                , slotsTakenBadge
                , previewDamage
                , typeBadge
                , rangeBadge
                , pointBadge
                ]

        ( _, mCurrentClip ) =
            Model.Shared.getAmmoClip weapon.specials

        renderSpecialFunc special =
            let
                renderedSpecial =
                    View.Utils.renderSpecial
                        isPreview
                        (Just <| UpdateAmmoUsed vehicle.key weapon)
                        special
            in
            li [] [ renderedSpecial ]

        specials =
            case weapon.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc weapon.specials
    in
    View.EquipmentLayout.render
        (not isPreview)
        [ Grid.row []
            [ Grid.col [ Col.xs, Col.md12 ]
                [ h6 [] [ text <| weapon.name ++ " " ] ]
            , Grid.col [ Col.xsAuto, Col.md12 ] [ fireButton ]
            , Grid.col [ Col.xsAuto, Col.md12 ]
                [ Btn.button
                    [ Btn.small
                    , Btn.outlineDanger
                    , Btn.block
                    , Btn.onClick <| DeleteWeapon vehicle.key weapon
                    , Btn.attrs
                        [ classList [ ( "d-none", isPreview ) ]
                        , class "mt-2"
                        ]
                    ]
                    [ icon "trash-alt" ]
                ]
            ]
        ]
        [ factsHolder, specials ]
