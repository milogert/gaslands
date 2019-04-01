module View.Vehicle exposing (renderCard, renderDetails, renderPreview, renderPrint)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Form.Textarea as Textarea
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
        , h5
        , hr
        , li
        , small
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
        , placeholder
        , style
        )
import Html.Events exposing (onClick, onInput)
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
import View.Utils exposing (icon, iconClass)
import View.Weapon


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

        vehicleTypeBadge =
            View.Utils.factBadge vtype

        weightBadge =
            View.Utils.factBadge <|
                fromVehicleWeight v.weight
                    ++ "-weight"

        handlingBadge =
            View.Utils.factBadge <|
                (String.fromInt <| totalHandling v)
                    ++ " handling"

        equipmentUsed =
            List.sum (List.map .slots v.weapons)

        equipmentRemaining =
            String.fromInt <| v.equipment - equipmentUsed

        crewBadge =
            View.Utils.factBadge <| (String.fromInt <| totalCrew v) ++ " total crew"

        isCrewAvailable =
            totalCrew v > View.Utils.crewUsed v

        crewRemaining =
            String.fromInt <| totalCrew v - View.Utils.crewUsed v

        wrecked =
            v.hull.current >= totalHull v

        canActivate =
            model.gearPhase <= v.gear.current

        activatedText =
            case ( v.activated, canActivate ) of
                ( True, False ) ->
                    "Activated"

                ( _, False ) ->
                    "Cannot be Activated"

                ( _, _ ) ->
                    "Activate"

        activateButton =
            div
                [ class "vehicle-activate-button-holder mb-2"
                , hidden <| not cfg.showActivateButton || wrecked
                ]
                [ Button.button
                    [ Button.primary
                    , Button.small
                    , Button.block
                    , Button.onClick <| VehicleMsg <| UpdateActivated v.key (not v.activated)
                    , Button.disabled <| not canActivate || v.activated
                    ]
                    [ text activatedText ]
                ]

        factsHolder =
            View.Utils.factsHolder
                [ vehicleTypeBadge
                , pointsCostBadge
                , weightBadge
                , crewBadge
                , handlingBadge
                , equipmentSlotsBadge
                , maxHullBadge
                , maxGearBadge
                ]

        photoPlus =
            div
                [ hidden <| not cfg.showPhoto ]
                [ View.Photo.view model v ]

        printButton =
            Button.button
                [ Button.roleLink
                , Button.attrs [ hidden <| not cfg.showPrintButton ]
                , Button.onClick <| To <| ViewPrinterFriendly [ v ]
                ]
                [ icon "print" ]

        stats =
            Grid.simpleRow
                [ Grid.col
                    [ Col.xs3
                    , Col.lg2
                    , Col.attrs [ hidden <| not cfg.showPhoto ]
                    ]
                    [ photoPlus ]
                , Grid.col [ Col.xs ]
                    [ activateButton, factsHolder ]
                , Grid.col
                    [ Col.xs12
                    , Col.lgAuto
                    , Col.attrs [ hidden <| not cfg.showPrintButton ]
                    ]
                    [ printButton ]
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
                            Textarea.textarea
                                [ Textarea.onInput <| VehicleMsg << UpdateNotes v.key
                                , Textarea.attrs [ placeholder "Notes" ]
                                , Textarea.value v.notes
                                ]

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

        addonListButton onClick icon_ text_ =
            Button.button
                [ Button.roleLink
                , Button.small
                , Button.onClick onClick
                , Button.attrs [ hidden <| not cfg.showAddonButton ]
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
                            (View.Weapon.RenderConfig
                                (not cfg.printDetails)
                                False
                                False
                                cfg.printDetails
                                (not cfg.printDetails)
                            )
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
                            , addonListButton (ShowModal "weapon") "plus" "Weapon"
                            , addonListButton (WeaponMsg <| AddWeapon v.key handgun) "plus" "Handgun"
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
                            , addonListButton (ShowModal "upgrade") "plus" "Upgrade"
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

        pointsCostBadge =
            View.Utils.factBadge <|
                (String.fromInt <| vehicleCost v)
                    ++ " points"

        equipmentSlotsBadge =
            let
                slots =
                    case v.equipment of
                        1 ->
                            "slot"

                        _ ->
                            "slots"
            in
            View.Utils.factBadge <|
                String.fromInt v.equipment
                    ++ " build "
                    ++ slots

        maxHullBadge =
            v
                |> totalHull
                |> String.fromInt
                |> (\s -> s ++ " max hull")
                |> View.Utils.factBadge

        maxGearBadge =
            v
                |> totalGear
                |> String.fromInt
                |> (\s -> s ++ " max gear")
                |> View.Utils.factBadge

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
                [ Button.button
                    [ Button.danger
                    , Button.small
                    , Button.onClick <| VehicleMsg <| DeleteVehicle v.key
                    ]
                    [ icon "trash-alt" ]
                , Button.button
                    [ Button.info
                    , Button.small
                    , Button.attrs [ class "float-right" ]
                    , Button.onClick <| To <| ViewDetails v
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


renderCard : Model -> Vehicle -> Card.Config Msg
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

        cardDisplay =
            case v.hull.current >= totalHull v of
                True ->
                    [ Card.outlineDanger ]

                False ->
                    []
    in
    Card.config cardDisplay
        |> Card.headerH4 [] [ header ]
        |> Card.block [] (List.map (\b -> Block.text [] [ b ]) body)
        |> Card.footer [] [ footer ]


renderPreview : Model -> Vehicle -> Html Msg
renderPreview model v =
    let
        name =
            Input.text
                [ Input.small
                , Input.placeholder "Name"
                , Input.onInput <| VehicleMsg << TmpName
                , Input.value v.name
                , Input.attrs [ Spacing.mr1 ]
                ]

        header =
            h4 [ class "form-inline card-title" ]
                [ name
                , small [] [ text <| "[" ++ Model.Shared.fromExpansion v.expansion ++ "]" ]
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
