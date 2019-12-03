module View.Vehicle exposing (renderCard, renderDetails, renderPreview, renderPrint)

import Bulma.Modifiers exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Form exposing (..)
import Bulma.Elements exposing (..)
import Bootstrap.Badge as Badge
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Html
    exposing
        ( Html
        , div
        , h2
        , h4
        , a
        , h5
        , hr
        , li
        , small
        , textarea
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( checked
        , class
        , classList
        , disabled
        , hidden
        , href
        , placeholder
        , style
        )
import Html.Events exposing (onClick, onInput)
import Model.Features
import Model.Model exposing (..)
import Model.Shared
import Model.Sponsors exposing (..)
import Model.Utils exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (handgun)
import Model.Weapon.Model exposing (..)
import View.Photo
import View.Sponsor
import View.Upgrade
import View.Utils exposing (icon, iconClass, plural)
import View.Weapon exposing (defaultWeaponConfig)


type alias RenderConfig =
    { showActivateButton : Bool
    , showPhoto : Bool
    , showPrintButton : Bool
    , showCounters : Bool
    , printCounters : Bool
    , printNotes : Bool
    , inputNotes : Bool
    , showAddonButton : Bool
    , showDetails : Bool
    , printDetails : Bool
    , showPerks : Bool
    , printPerks : Bool
    , previewPerks : Bool
    , showDetailsButton : Bool
    }


config : RenderConfig
config =
    RenderConfig
        False
        False
        False
        False
        False
        False
        False
        False
        False
        False
        False
        False
        False
        False


type alias ConfiguredVehicle =
    { header : Html Msg
    , activationButton : Html Msg
    , badges : List (Html Msg)
    , counters : List (Html Msg)
    , weapons : Html Msg
    , upgrades : Html Msg
    , availalbePerks : Html Msg
    , footer : Html Msg
    }


configure : Model -> RenderConfig -> Vehicle -> ( Html Msg, List (Html Msg), Html Msg )
configure model cfg v =
    let
        ignore_currentView =
            model.view

        vtype =
            fromVehicleType v.vtype

        pointsDisplay =
            (String.fromInt <| vehicleCost v) ++ " points"

        weightDisplay =
            fromVehicleWeight v.weight ++ "-weight"

        equipmentUsed =
            List.sum (List.map .slots v.weapons)

        equipmentRemaining =
            String.fromInt <| v.equipment - equipmentUsed

        crewDisplay =
            (String.fromInt <| totalCrew v) ++ " total crew"

        handlingDisplay =
            (String.fromInt <| totalHandling v) ++ " handling"

        equipmentSlotsDisplay =
            String.fromInt v.equipment ++ " build slot" ++ plural v.equipment

        maxHullDisplay =
            v
                |> totalHull
                |> String.fromInt
                |> (\s -> s ++ " max hull")

        maxGearDisplay =
            v
                |> totalGear
                |> String.fromInt
                |> (\s -> s ++ " max gear")

        isCrewAvailable =
            totalCrew v > View.Utils.crewUsed v

        wrecked =
            v.hull.current >= totalHull v

        factsHolder =
            View.Utils.factsHolder
                [ vtype
                , pointsDisplay
                , weightDisplay
                , crewDisplay
                , handlingDisplay
                , equipmentSlotsDisplay
                , maxHullDisplay
                , maxGearDisplay
                ]

        photoPlus =
            div
                [ hidden <| not cfg.showPhoto ]
                [ View.Photo.view model v ]
                |> Model.Features.withDefault
                    "feature-car-photo"
                    (text "")

        stats =
            Grid.simpleRow
                [ Grid.col
                    [ Col.xs3
                    , Col.lg2
                    , Col.attrs [ hidden <| not cfg.showPhoto ]
                    ]
                    [ photoPlus ]
                , Grid.col [ Col.xs ]
                    [ factsHolder ]
                ]

        gearCounter =
            case ( cfg.printCounters, wrecked ) of
                ( True, _ ) ->
                    div [ class "gear-die" ] [ iconClass "fas fa-lg" "cogs" [ "mx-auto" ] ]

                ( _, True ) ->
                    text ""

                ( _, False ) ->
                    counterElement
                        (iconClass "fas" "cogs" [ "mx-auto" ])
                        1
                        (totalGear v)
                        v.gear.current
                        (ShiftGear v.key -1)
                        (ShiftGear v.key 1)
                        (UpdateGear v.key)

        hazardCounter =
            case cfg.printCounters of
                True ->
                    Grid.row [ Row.attrs [ class "mb-2" ] ]
                        [ Grid.col [ Col.md1 ] [ iconClass "fas fa-lg" "exclamation-triangle" [ "mx-auto", "print-icon" ] ]
                        , Grid.col [ Col.md11 ] <|
                            List.repeat 6 (span [ class "hazard-check mr-1" ] [])
                        ]

                False ->
                    div []
                        [ counterElement
                            (iconClass "fas" "exclamation-triangle" [ "mx-auto" ])
                            0
                            6
                            v.hazards
                            (ShiftHazards v.key -1)
                            (ShiftHazards v.key 1)
                            (UpdateHazards v.key)
                        ]

        hullCounter =
            case cfg.printCounters of
                True ->
                    Grid.simpleRow
                        [ Grid.col [ Col.md1 ] [ iconClass "fas fa-lg" "shield-alt" [ "mx-auto", "print-icon" ] ]
                        , Grid.col [ Col.md11 ] <|
                            List.repeat (totalHull v) (div [ class "hazard-check mr-1" ] [])
                        ]

                False ->
                    counterElement
                        (iconClass "fas" "shield-alt" [ "mx-auto" ])
                        0
                        (totalHull v)
                        v.hull.current
                        (ShiftHull v.key -1)
                        (ShiftHull v.key 1)
                        (UpdateHull v.key)

        counterHolder =
            case ( cfg.showCounters, cfg.printCounters ) of
                ( False, _ ) ->
                    text ""

                ( _, True ) ->
                    Grid.simpleRow
                        [ Grid.col [ Col.mdAuto ] [ gearCounter ]
                        , Grid.col [ Col.md ]
                            [ hazardCounter
                            , hullCounter
                            ]
                        ]

                ( _, False ) ->
                    div []
                        [ gearCounter
                        , hazardCounter
                        , hullCounter
                        ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial False False Nothing Nothing special ]

        specials =
            case v.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc v.specials

        specialHolder =
            div [] [ specials ]

        notes =
            let
                notesBody =
                    case ( cfg.printNotes, cfg.inputNotes ) of
                        ( True, _ ) ->
                            text v.notes

                        ( _, True ) ->
                            textarea
                                [ onInput <| VehicleMsg << UpdateNotes v.key
                                , placeholder "Notes"
                                ]
                                [ text v.notes ]

                        _ ->
                            text ""
            in
            case ( cfg.inputNotes, cfg.printNotes, v.notes ) of
                ( False, False, _ ) ->
                    text ""

                ( _, True, "" ) ->
                    text ""

                _ ->
                    View.Utils.detailSection [ text "Notes" ] [ notesBody ]

        addonListButton href_ icon_ text_ =
            a
                [ class "button"
                , hidden <| not cfg.showAddonButton
                , href href_
                ]
                [ icon icon_, text text_ ]

        weaponsUsingSlots =
            List.sum <| List.map .slots v.weapons

        upgradeUsingSlots =
            List.sum <| List.map .slots v.upgrades

        totalSlotsUsed =
            weaponsUsingSlots + upgradeUsingSlots

        weaponsListBody =
            case v.weapons of
                [] ->
                    [ text "No Equipped Weapons" ]

                _ ->
                    List.map
                        (View.Weapon.render
                            { defaultWeaponConfig
                                | showFireButton = not cfg.printDetails
                                , previewSpecials = False
                                , printSpecials = cfg.printDetails
                                , showDeleteButton = not cfg.printDetails
                            }
                            model
                            v
                        )
                        v.weapons

        weaponListAvailableBadge =
            case isCrewAvailable of
                True ->
                    Badge.badgeSuccess

                False ->
                    Badge.badgeDanger

        weaponList =
            case ( v.weapons, cfg.printDetails, cfg.showDetails ) of
                ( _, _, False ) ->
                    text ""

                ( [], True, _ ) ->
                    text ""

                _ ->
                    View.Utils.detailSection
                        [ text "Weapon List"
                        , small []
                            [ weaponListAvailableBadge [ Spacing.ml2 ]
                                [ " crew used"
                                    |> (++) (String.fromInt <| totalCrew v)
                                    |> (++) "/"
                                    |> (++) (String.fromInt <| View.Utils.crewUsed v)
                                    |> text
                                ]
                            , Badge.badgeDark [ Spacing.ml2 ]
                                [ " slots used"
                                    |> (++) (String.fromInt <| v.equipment)
                                    |> (++) "/"
                                    |> (++) (String.fromInt <| weaponsUsingSlots)
                                    |> text
                                ]
                            , addonListButton ("/new/weapon/" ++ v.key) "plus" "Weapon"
                            , a
                                [ class "button"
                                , onClick (WeaponMsg <| AddWeapon v.key handgun)
                                , hidden <| not cfg.showAddonButton
                                ]
                                [ icon "plus", text "Handgun" ]
                            ]
                        ]
                        weaponsListBody

        upgradeListBody =
            case v.upgrades of
                [] ->
                    [ text "No Equipped Upgrades" ]

                _ ->
                    List.map
                        (View.Upgrade.render
                            (View.Upgrade.RenderConfig
                                False
                                cfg.printDetails
                                (not cfg.printDetails)
                            )
                            model
                            v
                        )
                        v.upgrades

        upgradeList =
            case ( v.upgrades, cfg.printDetails, cfg.showDetails ) of
                ( _, _, False ) ->
                    text ""

                ( [], True, _ ) ->
                    text ""

                _ ->
                    View.Utils.detailSection
                        [ text "Upgrade List"
                        , small []
                            [ Badge.badgeDark [ Spacing.ml2 ]
                                [ " slots used"
                                    |> (++) (String.fromInt <| v.equipment)
                                    |> (++) "/"
                                    |> (++) (String.fromInt <| upgradeUsingSlots)
                                    |> text
                                ]
                            , addonListButton ("/new/upgrade/" ++ v.key) "plus" "Upgrade"
                            ]
                        ]
                        upgradeListBody

        availablePerks =
            case ( model.sponsor, cfg.showPerks, cfg.printPerks ) of
                ( Just sponsor, _, True ) ->
                    View.Utils.detailSection
                        [ text "Perks Available from "
                        , text sponsor.name
                        ]
                        [ sponsor
                            |> .grantedClasses
                            |> View.Sponsor.renderPerkList v.perks
                        ]

                ( Nothing, _, _ ) ->
                    text ""

                ( _, False, _ ) ->
                    text ""

                ( Just sponsor, True, _ ) ->
                    View.Utils.detailSection
                        [ text "Perks Available from "
                        , text sponsor.name
                        ]
                        [ Grid.simpleRow
                            (sponsor
                                |> .grantedClasses
                                |> List.map (View.Sponsor.renderPerkClass v)
                            )
                        ]

        expansion =
            Model.Shared.fromExpansion v.expansion

        header =
            h2 []
                [ text v.name
                , small [] [ text <| " [" ++ expansion ++ "]" ]
                ]

        body : List (Html Msg)
        body =
            [ stats
            , counterHolder
            , specialHolder
            , notes
            , weaponList
            , upgradeList
            , availablePerks
            ]

        footer =
            div
                [ class "buttons"
                , classList [ ( "d-none", wrecked ) ]
                ]
                [ button
                    { buttonModifiers
                    | color = Danger
                    , size = Small
                    }
                    [ onClick <| VehicleMsg <| DeleteVehicle v.key
                    ]
                    [ icon "trash-alt" ]
                , a
                    [ class "button"
                    , class "float-right"
                    , href <| "/details/" ++ v.key
                    ]
                    [ icon "info" ]
                ]
    in
    ( header, body, footer )


renderDetails : Model -> Vehicle -> Html Msg
renderDetails model v =
    let
        ( _, body, _ ) =
            configure
                model
                { config
                    | showActivateButton = True
                    , showPhoto = True
                    , showPrintButton = True
                    , showCounters = True
                    , inputNotes = True
                    , showPerks = True
                    , showAddonButton = True
                    , showDetails = True
                }
                v
    in
    body
        |> List.map (\b -> Grid.col [ Col.xs12 ] [ b ])
        |> Grid.simpleRow


renderCard : Model -> Vehicle -> Html Msg
renderCard model v =
    let
        ( header, body, footer ) =
            configure
                model
                { config
                    | showActivateButton = True
                    , showCounters = True
                    , showDetailsButton = True
                }
                v
    in
    div []
        [ h4 [] [ header ]
        , div [] body
        , div [] [ footer ]
        ]


renderPreview : Model -> Vehicle -> Html Msg
renderPreview model v =
    let
        name =
            case v.name of
                "" ->
                    "..."

                _ ->
                    v.name

        header =
            h4 []
                [ text name
                , small
                    [ Spacing.ml2 ]
                    [ text <| "[" ++ Model.Shared.fromExpansion v.expansion ++ "]" ]
                ]

        ( _, body, _ ) =
            configure
                model
                { config | previewPerks = True }
                v
    in
    Grid.simpleRow
        [ Grid.col [ Col.md12 ] [ header ]
        , Grid.col [ Col.md12 ] body
        ]


renderPrint : Model -> Vehicle -> Html Msg
renderPrint model v =
    let
        ( header, body, _ ) =
            configure
                model
                { config
                    | printCounters = True
                    , showCounters = True
                    , printNotes = True
                    , printPerks = True
                    , showPerks = True
                    , showDetails = True
                    , printDetails = True
                }
                v
    in
    header
        :: body
        |> List.map (\b -> Grid.col [ Col.xs12 ] [ b ])
        |> Grid.simpleRow


counterElement :
    Html Msg
    -> Int
    -> Int
    -> Int
    -> (Int -> Int -> VehicleEvent)
    -> (Int -> Int -> VehicleEvent)
    -> (String -> VehicleEvent)
    -> Html Msg
counterElement icon_ min max counterValue decrementMsg incrementMsg inputMsg =
    connectedFields Centered []
    [ span
        [ style "min-width" "4rem"
        , style "text-align" "center"
        ]
        [ icon_ ]
    , button
        [ Button.outlineSecondary
        , Button.onClick <| VehicleMsg <| decrementMsg min max
        , Button.disabled <| min == counterValue
        ]
        [ icon "minus" ]
    ]
    InputGroup.config
        (InputGroup.number
            [ Input.onInput <| VehicleMsg << inputMsg
            , Input.value <| String.fromInt counterValue
            , Input.attrs
                [ style "text-align" "center"
                , Html.Attributes.min <| String.fromInt min
                , Html.Attributes.max <| String.fromInt max
                ]
            ]
        )
        |> InputGroup.small
        |> InputGroup.attrs [ class "my-2" ]
        |> InputGroup.predecessors
            [ InputGroup.span
                [ style "min-width" "4rem"
                , style "text-align" "center"
                ]
                [ icon_ ]
            , InputGroup.button
                [ Button.outlineSecondary
                , Button.onClick <| VehicleMsg <| decrementMsg min max
                , Button.disabled <| min == counterValue
                ]
                [ icon "minus" ]
            ]
        |> InputGroup.successors
            [ InputGroup.button
                [ Button.outlineSecondary
                , Button.onClick <| VehicleMsg <| incrementMsg min max
                , Button.disabled <| counterValue >= max
                ]
                [ icon "plus" ]

            {--, InputGroup.span
                [ style "min-width" "4rem" ]
                [ span [ class "mx-auto" ] [ text <| "of " ++ String.fromInt max ] ]--}
            ]
        |> InputGroup.view
