module View.Vehicle exposing (render, renderPreview)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul, video)
import Html.Attributes exposing (attribute, autoplay, checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, style, type_, value)
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


render : Model -> CurrentView -> Vehicle -> Html Msg
render model currentView v =
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

        name =
            div [ class "vehicle-name-holder" ]
                [ h3
                    [ class "vehicle-name" ]
                    [ text v.name ]
                ]

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
                [ button
                    [ class "btn btn-sm btn-primary btn-block form-control"
                    , onClick (UpdateActivated v (not v.activated))
                    , checked v.activated
                    , disabled <| not canActivate || v.activated
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

        header =
            Grid.col [ Col.xs12 ]
                [ Grid.row []
                    [ Grid.col
                        [ Col.xs6
                        , Col.md3
                        , Col.attrs
                            [ classList [ ( "d-none", currentView /= Details v ) ] ]
                        ]
                        [ View.Photo.view model v ]
                    , Grid.col
                        [ Col.xs6
                        , Col.md9
                        , Col.attrs
                            [ classList
                                [ ( "col-12", currentView /= Details v )
                                , ( "col-md-12", currentView /= Details v )
                                ]
                            ]
                        ]
                        [ name, activateButton, factsHolder ]
                    ]
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
                        (ShiftGear v -1)
                        (ShiftGear v 1)
                        (UpdateGear v)

        hazardCounter =
            div []
                [ counterElement
                    (iconClass "fas" "exclamation-triangle" [ "mx-auto" ])
                    0
                    6
                    v.hazards
                    (ShiftHazards v -1)
                    (ShiftHazards v 1)
                    (UpdateHazards v)
                ]

        hullCounter =
            counterElement
                (iconClass "fas" "shield-alt" [ "mx-auto" ])
                0
                (totalHull v)
                v.hull.current
                (ShiftHull v -1)
                (ShiftHull v 1)
                (UpdateHull v)

        counterHolder =
            Grid.col [ Col.xs12 ]
                [ gearCounter, hazardCounter, hullCounter ]

        renderSpecialFunc special =
            li [] [ View.Utils.renderSpecial False Nothing 0 special ]

        specials =
            case v.specials of
                [] ->
                    text ""

                _ ->
                    ul [] <| List.map renderSpecialFunc v.specials

        specialHolder =
            Grid.col [ Col.xs12 ] [ specials ]

        notes =
            Grid.col
                [ Col.xs12
                , Col.attrs
                    [ class "vehicle-notes-holder"
                    , classList [ ( "d-none", currentView == Overview ) ]
                    ]
                ]
                [ textarea
                    [ onInput (UpdateNotes v)
                    , class "form-control"
                    , placeholder "Notes"
                    ]
                    [ text v.notes ]
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
                    [ button
                        [ onClick <| ToNewWeapon v
                        , class "btn btn-sm btn-link"
                        ]
                        [ icon "plus", text "Weapon" ]
                    , button
                        [ onClick <| AddWeapon v handgun
                        , class "btn btn-sm btn-link"
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
                    [ button
                        [ onClick <| ToNewUpgrade v
                        , class "btn btn-sm btn-link ml-2"
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

        body =
            Grid.row
                [ Row.attrs
                    [ class "vehicle-body row"
                    , classList [ ( "card-text", currentView /= Details v ) ]
                    ]
                ]
                [ header
                , counterHolder
                , specialHolder
                , notes
                , Grid.col
                    [ Col.xs12
                    , Col.attrs
                        [ class "list-holder", classList [ ( "d-none", wrecked ) ] ]
                    ]
                    [ weaponList
                    , upgradeList
                    , availablePerks
                    ]
                ]

        footer =
            div
                [ class "buttons"
                , classList [ ( "d-none", wrecked ) ]
                ]
                [ button
                    [ class "btn btn-sm btn-danger"
                    , onClick <| DeleteVehicle v
                    ]
                    [ icon "trash-alt" ]
                , button
                    [ class "btn btn-sm btn-info float-right"
                    , classList [ ( "d-none", currentView /= Overview ) ]
                    , onClick <| ToDetails v
                    ]
                    [ icon "info" ]
                ]
    in
    case currentView of
        Details _ ->
            body

        _ ->
            View.Utils.card [ ( "border-danger", wrecked ) ] body footer False


renderPreview : Model -> CurrentView -> Vehicle -> Html Msg
renderPreview model currentView v =
    let
        name =
            input
                [ onInput TmpName
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
            li [] [ View.Utils.renderSpecial True Nothing 0 special ]

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
            div [ classList [ ( "card-text", currentView /= Details v ) ] ]
                [ header
                , factsHolder
                , gearBox
                , hullChecks
                , specials
                ]
    in
    case currentView of
        Details _ ->
            div [] [ body ]

        _ ->
            View.Utils.card [] body (text "") True


counterElement :
    Html Msg
    -> Int
    -> Int
    -> Int
    -> (Int -> Int -> Msg)
    -> (Int -> Int -> Msg)
    -> (String -> Msg)
    -> Html Msg
counterElement icon_ min max counterValue decrementMsg incrementMsg inputMsg =
    div [ class "mb-2 input-group" ]
        [ div [ class "input-group-prepend" ]
            [ span
                [ class "input-group-text"
                , style "min-width" "4rem"
                , style "text-align" "center"
                ]
                [ icon_ ]
            , button
                [ class "btn btn-outline-secondary"
                , onClick <| decrementMsg min max
                , disabled <| min == counterValue
                ]
                [ text "-" ]
            ]
        , input
            [ class "form-control"
            , type_ "number"
            , onInput inputMsg
            , value <| String.fromInt counterValue
            , Html.Attributes.min <| String.fromInt min
            , Html.Attributes.max <| String.fromInt max
            , style "text-align" "center"
            ]
            []
        , div [ class "input-group-append" ]
            [ button
                [ class "btn btn-outline-secondary"
                , onClick <| incrementMsg min max
                , disabled <| counterValue >= max
                ]
                [ text "+" ]
            , span
                [ class "input-group-text"
                , style "min-width" "4rem"
                ]
                [ span [ class "mx-auto" ] [ text <| "of " ++ String.fromInt max ] ]
            ]
        ]
