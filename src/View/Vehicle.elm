module View.Vehicle exposing (renderCard, renderDetails, renderPreview, renderPrint)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Solid as Icon
import Html
    exposing
        ( Html
        , a
        , div
        , h2
        , h4
        , h5
        , hr
        , li
        , small
        , span
        , text
        , textarea
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
        , value
        )
import Html.Events exposing (onClick, onInput)
import Model.Features
import Model.Model exposing (..)
import Model.Shared
import Model.Sponsors exposing (..)
import Model.Utils exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Views exposing (..)
import Model.Weapon.Common exposing (handgun)
import Model.Weapon.Model exposing (..)
import View.Photo
import View.Sponsor
import View.Upgrade
import View.Utils exposing (plural, tagGen, tagList)
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


configure : Model -> RenderConfig -> Vehicle -> ( Html Msg, Html Msg, Html Msg )
configure model cfg v =
    let
        ignore_currentView =
            model.view

        vtype =
            ( fromVehicleType v.vtype, Nothing )

        pointsDisplay =
            ( "points", Just <| String.fromInt <| vehicleCost v )

        weightDisplay =
            ( fromVehicleWeight v.weight ++ "-weight", Nothing )

        equipmentUsed =
            List.sum (List.map .slots v.weapons)

        equipmentRemaining =
            String.fromInt <| v.equipment - equipmentUsed

        equipmentSlotsDisplay =
            ( "build slots", Just <| String.fromInt v.equipment )

        crewDisplay =
            ( "total crew", Just <| String.fromInt <| totalCrew v )

        handlingDisplay =
            ( "handling", Just <| String.fromInt <| totalHandling v )

        maxHullDisplay =
            ( "max hull"
            , v
                |> totalHull
                |> String.fromInt
                |> Just
            )

        maxGearDisplay =
            ( "max gear"
            , v
                |> totalGear
                |> String.fromInt
                |> Just
            )

        isCrewAvailable =
            totalCrew v > View.Utils.crewUsed v

        factsHolder =
            [ vtype
            , pointsDisplay
            , weightDisplay
            , crewDisplay
            , handlingDisplay
            , equipmentSlotsDisplay
            , maxHullDisplay
            , maxGearDisplay
            ]
                |> List.map (\( title, value ) -> tagGen ( title, Bulma.Modifiers.Light ) ( value, Info ))
                |> List.map (\t -> control controlModifiers [] [ t ])
                |> multilineFields
                    []

        photoPlus =
            div
                [ hidden <| not cfg.showPhoto ]
                [ View.Photo.view model v ]
                |> Model.Features.withDefault
                    "feature-car-photo"
                    (text "")

        stats =
            div
                []
                [ photoPlus
                , factsHolder
                ]

        gearCounter =
            case ( cfg.printCounters, isWrecked v ) of
                ( True, _ ) ->
                    div [ class "gear-die" ] [ Icon.cogs |> Icon.viewIcon ]

                ( _, True ) ->
                    text ""

                ( _, False ) ->
                    counterElement
                        (Icon.cogs |> Icon.viewIcon)
                        1
                        (totalGear v)
                        v.gear.current
                        (ShiftGear v.key -1)
                        (ShiftGear v.key 1)

        hazardCounter =
            case cfg.printCounters of
                True ->
                    columns columnsModifiers
                        []
                        [ column columnModifiers
                            []
                            [ Icon.viewStyled [ class "print-icon" ] Icon.exclamationTriangle ]
                        , column columnModifiers
                            []
                            (List.repeat 6 (span [ class "hazard-check mr-1" ] []))
                        ]

                False ->
                    counterElement
                        (Icon.exclamationTriangle |> Icon.viewIcon)
                        0
                        6
                        v.hazards
                        (ShiftHazards v.key -1)
                        (ShiftHazards v.key 1)

        hullCounter =
            case cfg.printCounters of
                True ->
                    columns columnsModifiers
                        []
                        [ column columnModifiers
                            []
                            [ Icon.viewStyled [ class "print-icon" ] Icon.shieldAlt ]
                        , column columnModifiers
                            []
                            (List.repeat (totalHull v) (span [ class "hazard-check mr-1" ] []))
                        ]

                False ->
                    counterElement
                        (Icon.shieldAlt |> Icon.viewIcon)
                        0
                        (totalHull v)
                        v.hull.current
                        (ShiftHull v.key -1)
                        (ShiftHull v.key 1)

        counterHolder =
            case ( cfg.showCounters, cfg.printCounters ) of
                ( False, _ ) ->
                    text ""

                ( _, _ ) ->
                    level []
                        [ levelItem [] [ gearCounter ]
                        , levelItem [] [ hazardCounter ]
                        , levelItem [] [ hullCounter ]
                        ]

        renderSpecialsFunc specialList =
            specialList
                |> List.map (View.Utils.specialToHeaderBody False False Nothing Nothing)
                |> List.map View.Utils.renderSpecialRow

        specials =
            case v.specials of
                [] ->
                    text <| "No special rules for " ++ v.name ++ "."

                _ ->
                    div [] <| renderSpecialsFunc v.specials

        specialHolder =
            View.Utils.detailSection "Special List"
                []
                [ specials ]

        mNotesBody =
            case ( cfg.printNotes, cfg.inputNotes ) of
                ( True, _ ) ->
                    Just <| text v.notes

                ( _, True ) ->
                    Just <|
                        controlTextArea controlTextAreaModifiers
                            []
                            [ onInput <| VehicleMsg << UpdateNotes v.key
                            , placeholder "Notes"
                            ]
                            [ text v.notes ]

                _ ->
                    Nothing

        addonListButton buttonMsg icon text_ =
            button
                { buttonModifiers
                    | iconLeft = Just ( Standard, [], Icon.viewIcon icon )
                    , size = Small
                }
                [ class "button"
                , hidden <| not cfg.showAddonButton
                , onClick <| ViewMsg buttonMsg
                ]
                [ text text_ ]

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
                    v.weapons
                        |> List.indexedMap
                            (\index weapon ->
                                View.Weapon.render
                                    { defaultWeaponConfig
                                        | showFireButton = not cfg.printDetails
                                        , previewSpecials = False
                                        , printSpecials = cfg.printDetails
                                        , showDeleteButton = not cfg.printDetails
                                        , highlightRow = 1 == modBy 2 index
                                    }
                                    model
                                    v
                                    weapon
                            )

        weaponListColor =
            case isCrewAvailable of
                True ->
                    Success

                False ->
                    Danger

        weaponList =
            case ( v.weapons, cfg.printDetails, cfg.showDetails ) of
                ( _, _, False ) ->
                    text ""

                ( [], True, _ ) ->
                    text ""

                _ ->
                    View.Utils.detailSection
                        "Weapon List"
                        [ addonListButton (ViewNew <| NewWeapon v.key) Icon.plus "Weapon"
                        , button
                            { buttonModifiers
                                | iconLeft = Just ( Standard, [], Icon.plus |> Icon.viewIcon )
                                , size = Small
                            }
                            [ onClick (WeaponMsg <| AddWeapon v.key handgun)
                            , hidden <| not cfg.showAddonButton
                            ]
                            [ text "Handgun" ]
                        ]
                        [ tagList
                            [ ( ( "crew used", Bulma.Modifiers.Light )
                              , ( Just <|
                                    (String.fromInt <| View.Utils.crewUsed v)
                                        ++ " / "
                                        ++ (String.fromInt <| totalCrew v)
                                , weaponListColor
                                )
                              )
                            , ( ( "slots used", Bulma.Modifiers.Light )
                              , ( Just <|
                                    ((String.fromInt <| weaponsUsingSlots)
                                        ++ " / "
                                        ++ (String.fromInt <| v.equipment)
                                    )
                                , weaponListColor
                                )
                              )
                            ]
                        , div [ class "thing-list weapon-list" ] weaponsListBody
                        ]

        upgradeListBody =
            case v.upgrades of
                [] ->
                    [ text "No Equipped Upgrades" ]

                _ ->
                    List.indexedMap
                        (\index upgrade ->
                            View.Upgrade.render
                                (View.Upgrade.RenderConfig
                                    False
                                    cfg.printDetails
                                    (not cfg.printDetails)
                                    (modBy 2 index == 1)
                                )
                                model
                                v
                                upgrade
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
                        "Upgrade List"
                        [ addonListButton (ViewNew <| NewUpgrade v.key) Icon.plus "Upgrade" ]
                        [ tagList
                            [ ( ( "slots used", Bulma.Modifiers.Light )
                              , ( Just <|
                                    ((String.fromInt <| upgradeUsingSlots)
                                        ++ " / "
                                        ++ (String.fromInt <| v.equipment)
                                    )
                                , Success
                                )
                              )
                            ]
                        , div [ class "thing-list upgrade-list" ] upgradeListBody
                        ]

        availablePerks =
            case ( model.sponsor, cfg.showPerks, cfg.printPerks ) of
                ( Just sponsor, _, True ) ->
                    View.Utils.detailSection
                        ("Perks available from " ++ sponsor.name)
                        []
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
                        ("Perks available from " ++ sponsor.name)
                        []
                        [ container []
                            (sponsor
                                |> .grantedClasses
                                |> List.map (View.Sponsor.renderPerkClass v)
                            )
                        ]

        expansion =
            Model.Shared.fromExpansion v.expansion

        showWrecked =
            case isWrecked v of
                True ->
                    Block

                False ->
                    Hidden

        canActivate =
            model.gearPhase <= v.gear.current && not (isWrecked v)

        activatedText =
            case ( v.activated, canActivate ) of
                ( _, False ) ->
                    "Cannot be Activated"

                ( True, _ ) ->
                    "Activated"

                ( _, _ ) ->
                    "Activate"

        activateButton =
            div
                [ class "vehicle-activate-button-holder mb-2"
                , hidden <| not cfg.showActivateButton
                ]
                [ button
                    { buttonModifiers
                        | color = Primary
                        , disabled = not canActivate || v.activated
                    }
                    [ onClick <| VehicleMsg <| UpdateActivated v.key (not v.activated)
                    ]
                    [ text activatedText ]
                ]

        header =
            level []
                [ levelLeft []
                    [ title H3
                        []
                        [ text v.name
                        , small [] [ text <| " [" ++ expansion ++ "]" ]
                        , div [ class "wrecked-display", display showWrecked ] [ text "WRECKED!" ]
                        ]
                    ]
                , levelRight []
                    [ activateButton ]
                ]

        left =
            column columnModifiers
                [ class "vehicle-column-left" ]
                [ factsHolder
                , counterHolder
                , specialHolder
                ]

        right =
            column columnModifiers
                [ class "vehicle-column-right" ]
                [ weaponList
                , upgradeList
                ]

        bottom =
            div [ class "vehicle-body-bottom" ]
                [ availablePerks
                ]

        body =
            div
                [ class "vehicle-body" ]
                [ columns columnsModifiers
                    [ class "vehicle-columns" ]
                    [ left, right ]
                , bottom
                ]

        footer =
            level
                [ class "button-bar" ]
                [ levelLeft [] []
                , levelRight []
                    [ levelItem []
                        [ button
                            { buttonModifiers
                                | color = Danger
                                , iconLeft = Just ( Standard, [], Icon.trashAlt |> Icon.viewIcon )
                            }
                            [ onClick <| VehicleMsg <| DeleteVehicle v.key
                            ]
                            [ text "Delete Vehicle" ]
                        ]
                    ]
                ]
    in
    ( header, body, footer )


renderDetails : Model -> Vehicle -> Html Msg
renderDetails model v =
    let
        ( header, body, footer ) =
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
    div []
        [ header
        , body
        , footer
        ]


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
    box []
        [ title H4 [] [ header ]
        , body
        , footer
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
            title H4
                []
                [ text name
                , small
                    []
                    [ text <| "[" ++ Model.Shared.fromExpansion v.expansion ++ "]" ]
                ]

        ( _, body, _ ) =
            configure
                model
                { config | previewPerks = True }
                v
    in
    div []
        [ header
        , body
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
    div []
        [ header
        , body
        ]


counterElement :
    Html Msg
    -> Int
    -> Int
    -> Int
    -> (Int -> Int -> VehicleEvent)
    -> (Int -> Int -> VehicleEvent)
    -> Html Msg
counterElement icon_ min max counterValue decrementMsg incrementMsg =
    level [ class "is-mobile" ]
        [ levelItem []
            [ controlButton
                { buttonModifiers
                    | iconLeft = Just ( Standard, [], icon_ )
                    , size = Small
                }
                []
                [ onClick <| VehicleMsg <| decrementMsg min max
                , disabled <| min == counterValue
                ]
                [ Icon.minus |> Icon.viewIcon ]
            ]
        , levelItem [ style "min-width" "3rem" ]
            [ text <| String.fromInt counterValue ]
        , levelItem []
            [ controlButton
                { buttonModifiers
                    | size = Small
                }
                []
                [ onClick <| VehicleMsg <| incrementMsg min max
                , disabled <| counterValue >= max
                ]
                [ Icon.plus |> Icon.viewIcon ]
            ]
        ]
