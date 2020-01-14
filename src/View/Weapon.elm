module View.Weapon exposing (defaultWeaponConfig, render)

import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html
    exposing
        ( Html
        , div
        , text
        )
import Html.Attributes
    exposing
        ( class
        , classList
        , value
        )
import Model.Model exposing (..)
import Model.Shared
import Model.Vehicle exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)
import View.EquipmentLayout
import View.Utils exposing (plural, tagGen)


type alias RenderConfig =
    { showFireButton : Bool
    , previewSpecials : Bool
    , printSpecials : Bool
    , showDeleteButton : Bool
    , highlightRow : Bool
    }


defaultWeaponConfig : RenderConfig
defaultWeaponConfig =
    RenderConfig True True False True False


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
                    ( "damage", Just <| fromDice attack )

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

        rangeBadge =
            ( "range", Just <| fromWeaponRange weapon.range )

        pointBadge =
            ( "point" ++ (plural <| weaponCost weapon), Just <| String.fromInt (weaponCost weapon) )

        factsHolder =
            [ mountPoint
            , slotsTakenBadge
            , previewDamage
            , rangeBadge
            , pointBadge
            ]
                |> List.map (\( title, value ) -> tagGen ( title, Bulma.Modifiers.Light ) ( value, Info ))
                |> List.map (\t -> control controlModifiers [] [ t ])
                |> multilineFields
                    [ class "weapon-facts" ]

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
        [ class "weapon", classList [ ( "alternate", cfg.highlightRow ) ] ]
        weapon
        deleteMsg
        [ factsHolder ]
        [ specials ]
