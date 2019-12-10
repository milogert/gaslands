module View.Weapon exposing (defaultWeaponConfig, render)

import Bootstrap.Button as Button
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Solid as Icon
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
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)
import View.EquipmentLayout
import View.Utils exposing (plural, tagGen)


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
                    ( "damage", Just <| "none" )

                Just attack ->
                    ( "damage", Just <| View.Utils.renderDice attack )

        mountPoint =
            case weapon.mountPoint of
                Just CrewFired ->
                    ( fromWeaponMounting CrewFired, Nothing )

                Just point ->
                    ( fromWeaponMounting point, Nothing )

                Nothing ->
                    ( "No mount point", Nothing )

        slotsTakenBadge =
            ( "slot" ++ plural weapon.slots ++ " used", Just <| String.fromInt weapon.slots )

        typeBadge =
            ( "type", Just <| fromWeaponType weapon.wtype )

        rangeBadge =
            ( "range", Just <| fromWeaponRange weapon.range )

        pointBadge =
            ( "point" ++ (plural <| weaponCost weapon), Just <| String.fromInt (weaponCost weapon) )

        factsHolder =
            [ mountPoint
            , slotsTakenBadge
            , previewDamage
            , typeBadge
            , rangeBadge
            , pointBadge
            ]
                |> List.map (\( title, value ) -> tagGen ( title, Bulma.Modifiers.Light ) ( value, Info ))
                |> List.map (\t -> control controlModifiers [] [ t ])
                |> multilineFields
                    []

        ( _, mCurrentClip ) =
            Model.Shared.getAmmoClip weapon.specials

        renderSpecialsFunc specialList =
            specialList
                |> List.map
                    (View.Utils.specialToHeaderBody
                        cfg.previewSpecials
                        cfg.printSpecials
                        (Just WeaponMsg)
                        (Just <| UpdateAmmoUsed vehicle.key weapon)
                    )
                |> List.map View.Utils.renderSpecialRow

        specials =
            case weapon.specials of
                [] ->
                    text <| "No special rules."

                _ ->
                    div [] <| renderSpecialsFunc weapon.specials

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
        [ factsHolder
        ]
        [ specials ]
