module View.Weapon exposing (defaultWeaponConfig, render)

import Bootstrap.Button as Button
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Html
    exposing
        ( Html
        , a
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
        , style
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
import View.Utils exposing (icon, plural)


type alias RenderConfig =
    { showFireButton : Bool
    , previewSpecials : Bool
    , printSpecials : Bool
    , showDeleteButton : Bool
    }


defaultWeaponConfig : RenderConfig
defaultWeaponConfig =
    RenderConfig True True False True


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

        previewDamage =
            case weapon.attack of
                Nothing ->
                    ""

                Just attack ->
                    View.Utils.renderDice attack

        fireButton =
            Button.button
                [ Button.small
                , Button.block
                , Button.disabled <| not canFire
                , Button.onClick firingToggle
                , Button.attrs
                    [ class "mr-2"
                    , hidden <| not cfg.showFireButton
                    , classList
                        [ ( "btn-secondary", weapon.status == WeaponFired )
                        , ( "btn-primary", weapon.status == WeaponReady )
                        ]
                    ]
                ]
                [ icon "crosshairs"
                , span []
                    [ text previewDamage
                    , attackResult
                    ]
                ]

        mountPoint =
            case weapon.mountPoint of
                Just CrewFired ->
                    fromWeaponMounting CrewFired

                Just point ->
                    fromWeaponMounting point

                Nothing ->
                    "No mount point"

        slotsTakenBadge =
            String.fromInt weapon.slots ++ " slot" ++ plural weapon.slots ++ " used"

        typeBadge =
            fromWeaponType weapon.wtype ++ " type"

        rangeBadge =
            fromWeaponRange weapon.range ++ " range"

        pointBadge =
            String.fromInt (weaponCost weapon) ++ " point(s)"

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

        deleteMsg =
            case cfg.showDeleteButton of
                True ->
                    Just (WeaponMsg << DeleteWeapon vehicle.key)

                False ->
                    Nothing
    in
    View.EquipmentLayout.render
        weapon
        deleteMsg
        [ fireButton
        , factsHolder
        ]
        [ specials ]
