module View.Vehicle exposing (renderCard, renderDetails, renderPreview)

import Bootstrap.Button as Btn
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html
    exposing
        ( Html
        , div
        , h4
        , input
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
        , placeholder
        , style
        )
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Sponsors exposing (..)
import Model.Utils exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (handgun)
import View.Photo
import View.Sponsor
import View.Upgrade
import View.Utils exposing (icon, iconClass)
import View.Weapon


configure : Model -> CurrentView -> Vehicle -> ( Html Msg, List (Html Msg), Html Msg )
configure model currentView v =
    let
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
                , classList [ ( "d-none", wrecked ) ]
                ]
                [ Btn.button
                    [ Btn.primary
                    , Btn.small
                    , Btn.block
                    , Btn.onClick <| VehicleMsg <| UpdateActivated v.key (not v.activated)
                    , Btn.disabled <| not canActivate || v.activated
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
                ]

        photoPlus =
            div
                [ classList [ ( "d-none", currentView /= ViewDetails v ) ] ]
                [ View.Photo.view model v ]

        stats =
            Grid.simpleRow
                [ Grid.col
                    [ Col.xs3
                    , Col.lg2
                    , Col.attrs
                        [ classList [ ( "d-none", currentView /= ViewDetails v ) ] ]
                    ]
                    [ photoPlus ]
                , Grid.col [ Col.xs ]
                    [ activateButton, factsHolder ]
                ]

        gearCounter =
            case wrecked of
                True ->
                    text ""

                False ->
                    counterElement
                        (iconClass "fas" "cogs" [ "mx-auto" ])
                        1
                        (totalGear v)
                        v.gear.current
                        (ShiftGear v.key -1)
                        (ShiftGear v.key 1)
                        (UpdateGear v.key)

        hazardCounter =
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
            counterElement
                (iconClass "fas" "shield-alt" [ "mx-auto" ])
                0
                (totalHull v)
                v.hull.current
                (ShiftHull v.key -1)
                (ShiftHull v.key 1)
                (UpdateHull v.key)

        counterHolder =
            div []
                [ gearCounter
                , hazardCounter
                , hullCounter
                ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial False Nothing special ]

        specials =
            case v.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc v.specials

        specialHolder =
            div [] [ specials ]

        notes =
            div
                [ class "vehicle-notes-holder"
                , classList [ ( "d-none", currentView == ViewDashboard ) ]
                ]
                [ Textarea.textarea
                    [ Textarea.onInput <| VehicleMsg << UpdateNotes v.key
                    , Textarea.attrs [ placeholder "Notes" ]
                    , Textarea.value v.notes
                    ]
                ]

        weaponsUsingSlots =
            List.sum <| List.map .slots v.weapons

        upgradeUsingSlots =
            List.sum <| List.map .slots v.upgrades

        totalSlotsUsed =
            weaponsUsingSlots + upgradeUsingSlots

        weaponList =
            View.Utils.detailSection
                currentView
                [ text "Weapon List"
                , small [ class "ml-2" ]
                    [ span
                        [ class "badge"
                        , classList
                            [ ( "badge-success", isCrewAvailable )
                            , ( "badge-danger", not isCrewAvailable )
                            ]
                        ]
                        [ text <| (String.fromInt <| View.Utils.crewUsed v) ++ "/" ++ (String.fromInt <| totalCrew v) ++ " crew used" ]
                    ]
                , small [ class "ml-2" ]
                    [ span [ class "badge badge-dark" ]
                        [ text <| (String.fromInt <| weaponsUsingSlots) ++ "/" ++ String.fromInt v.equipment ++ " slots used" ]
                    ]
                , small [ class "ml-2" ]
                    [ Btn.button
                        [ Btn.roleLink
                        , Btn.small
                        , Btn.onClick <| To <| ViewAddingWeapon v
                        ]
                        [ icon "plus", text "Weapon" ]
                    , Btn.button
                        [ Btn.roleLink
                        , Btn.small
                        , Btn.onClick <| AddWeapon v.key handgun
                        ]
                        [ icon "plus", text "Handgun" ]
                    ]
                ]
                (List.map (View.Weapon.render model v) v.weapons)

        upgradeList =
            View.Utils.detailSection
                currentView
                [ text "Upgrade List"
                , small [ class "ml-2" ]
                    [ span [ class "badge badge-dark" ]
                        [ text <| (String.fromInt <| upgradeUsingSlots) ++ "/" ++ String.fromInt v.equipment ++ " slots used" ]
                    ]
                , small []
                    [ Btn.button
                        [ Btn.roleLink
                        , Btn.small
                        , Btn.onClick <| To <| ViewAddingUpgrade v
                        , Btn.attrs [ class "ml-2" ]
                        ]
                        [ icon "plus", text "Upgrade" ]
                    ]
                ]
                (List.map (View.Upgrade.render model v) v.upgrades)

        availablePerks =
            case model.sponsor of
                Nothing ->
                    text ""

                Just sponsor ->
                    View.Utils.detailSection
                        currentView
                        [ text "Perks Available from "
                        , text <| fromSponsorType sponsor
                        ]
                        [ div [ class "row" ]
                            (sponsor
                                |> Model.Sponsors.typeToSponsor
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

        header =
            text v.name

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
                [ Btn.button
                    [ Btn.danger
                    , Btn.small
                    , Btn.onClick <| VehicleMsg <| DeleteVehicle v.key
                    ]
                    [ icon "trash-alt" ]
                , Btn.button
                    [ Btn.info
                    , Btn.small
                    , Btn.attrs
                        [ class "float-right"
                        , classList [ ( "d-none", currentView /= ViewDashboard ) ]
                        ]
                    , Btn.onClick <| To <| ViewDetails v
                    ]
                    [ icon "info" ]
                ]
    in
    ( header, body, footer )


renderDetails : Model -> CurrentView -> Vehicle -> Html Msg
renderDetails model currentView v =
    let
        ( header, body, footer ) =
            configure model currentView v
    in
    body
        |> List.map (\b -> Grid.col [ Col.xs12 ] [ b ])
        |> Grid.simpleRow


renderCard : Model -> CurrentView -> Vehicle -> Card.Config Msg
renderCard model currentView v =
    let
        ( header, body, footer ) =
            configure model currentView v

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


renderPreview : Model -> CurrentView -> Vehicle -> Html Msg
renderPreview model currentView v =
    let
        name =
            input
                [ onInput <| VehicleMsg << TmpName
                , placeholder "Name"
                , class "form-control mr-2"
                ]
                [ text v.name ]

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

        gearBox =
            div [] [ text <| "Gear Max: " ++ String.fromInt (totalGear v) ]

        hullChecks =
            div [] [ text <| "Hull Max: " ++ String.fromInt (totalHull v) ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial True Nothing special ]

        specials =
            case v.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc v.specials

        weaponsUsingSlots =
            List.sum <| List.map .slots v.weapons

        upgradeUsingSlots =
            List.sum <| List.map .slots v.upgrades

        totalSlotsUsed =
            weaponsUsingSlots + upgradeUsingSlots

        header =
            h4 [ class "form-inline card-title" ] [ name ]

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

        factsHolder =
            View.Utils.factsHolder
                [ vehicleTypeBadge
                , pointsCostBadge
                , weightBadge
                , crewBadge
                , handlingBadge
                , equipmentSlotsBadge
                ]

        body =
            div [ classList [ ( "card-text", currentView /= ViewDetails v ) ] ]
                [ factsHolder
                , gearBox
                , hullChecks
                , specials
                ]
    in
    case currentView of
        ViewDetails _ ->
            div [] [ body ]

        _ ->
            Card.config []
                |> Card.headerH4 [] [ header ]
                |> Card.block [] [ Block.text [] [ body ] ]
                |> Card.view


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
                [ Btn.outlineSecondary
                , Btn.onClick <| VehicleMsg <| decrementMsg min max
                , Btn.disabled <| min == counterValue
                ]
                [ icon "minus" ]
            ]
        |> InputGroup.successors
            [ InputGroup.button
                [ Btn.outlineSecondary
                , Btn.onClick <| VehicleMsg <| incrementMsg min max
                , Btn.disabled <| counterValue >= max
                ]
                [ icon "plus" ]

            {--, InputGroup.span
                [ style "min-width" "4rem" ]
                [ span [ class "mx-auto" ] [ text <| "of " ++ String.fromInt max ] ]--}
            ]
        |> InputGroup.view
