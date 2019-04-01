module View.Weapon exposing (RenderConfig, render)

import Bootstrap.Button as Btn
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Utilities.Spacing as Spacing
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
import Html.Attributes
    exposing
        ( class
        , classList
        , disabled
        , hidden
        , value
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared
import Model.Utils exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)
import View.EquipmentLayout
import View.Utils exposing (icon)


type alias RenderConfig =
    { showFireButton : Bool
    , showMountPointSelect : Bool
    , previewSpecials : Bool
    , printSpecials : Bool
    , showDeleteButton : Bool
    }


render : RenderConfig -> Model -> Vehicle -> Weapon -> Html Msg
render cfg model vehicle weapon =
    let
        firingToggle =
            case weapon.status of
                WeaponReady ->
                    WeaponMsg <| SetWeaponFired vehicle.key weapon

                WeaponFired ->
                    WeaponMsg <| SetWeaponFired vehicle.key weapon

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
                    , hidden <| not cfg.showFireButton
                    , classList
                        [ ( "btn-secondary", weapon.status == WeaponFired )
                        , ( "btn-primary", weapon.status == WeaponReady )
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

        mountPoint =
            case ( weapon.mountPoint, cfg.showMountPointSelect ) of
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
                            , Select.onChange <| WeaponMsg << TmpWeaponMountPoint
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
                        cfg.previewSpecials
                        cfg.printSpecials
                        (Just WeaponMsg)
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
        [ Grid.row []
            [ Grid.col [ Col.xs, Col.md12 ]
                [ h6 [] [ text <| weapon.name ++ " " ]
                , h6 []
                    [ small [] [ text <| Model.Shared.fromExpansion weapon.expansion ]
                    ]
                ]
            , Grid.col [ Col.xsAuto, Col.md12 ] [ fireButton ]
            , Grid.col [ Col.xsAuto, Col.md12 ]
                [ Btn.button
                    [ Btn.small
                    , Btn.outlineDanger
                    , Btn.block
                    , Btn.onClick <| WeaponMsg <| DeleteWeapon vehicle.key weapon
                    , Btn.attrs
                        [ Spacing.mt2
                        , hidden <| not cfg.showDeleteButton
                        ]
                    ]
                    [ icon "trash-alt" ]
                ]
            ]
        ]
        [ factsHolder, specials ]
