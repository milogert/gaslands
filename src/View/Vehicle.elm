module View.Vehicle exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, max, attribute)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Upgrade
import View.Utils
import View.Weapon


render : Model -> CurrentView -> Bool -> Vehicle -> Html Msg
render model currentView isPreview v =
    let
        name =
            if isPreview then
                input
                    [ onInput TmpName
                    , placeholder "Name"
                    , class "form-control mr-2"
                    ]
                    [ text v.name ]
            else
                span [ class "mr-2" ] [ text v.name ]

        vtype =
            vTToStr v.vtype

        vehicleType_ =
            text <| vtype

        weight =
            toString v.weight

        handling =
            toString v.handling

        equipmentUsed =
            List.sum (List.map .slots v.weapons)

        equipmentRemaining =
            toString <| v.equipment - equipmentUsed

        isCrewAvailable =
            v.crew > View.Utils.crewUsed v

        crewRemaining =
            toString <| v.crew - View.Utils.crewUsed v

        wipedOut =
            v.hazards >= 6

        canActivate =
            model.gearPhase <= v.gear.current

        activatedText =
            if not v.activated then
                "Activate"
            else
                "Activated"

        activatedCheck =
            div
                [ class "btn-group-toggle float-left mr-2"
                , classList [ ( "d-none", isPreview || wipedOut ) ]
                , attribute "data-toggle" "buttons"
                ]
                [ label
                    [ class "btn btn-sm btn-secondary"
                    , disabled <| not canActivate
                    ]
                    [ input
                        [ type_ "checkbox"
                        , onClick (UpdateActivated v (not v.activated))
                        , id ("activateCheck" ++ v.name)
                        , checked v.activated
                        , disabled <| not canActivate
                        ]
                        []
                    , text activatedText
                    ]
                ]

        gearBox =
            case (isPreview, wipedOut) of
                (True, _) ->
                    text <| "Gear Max: " ++ toString v.gear.max

                (_, True) ->
                    text ""

                (False, False) ->
                    div [ class "form-group form-row" ]
                        [ label [ for "gearBox", class "col-form-label" ]
                            [ text <| "Gear:" ]
                        , View.Utils.col ""
                            [ input
                                [ class "form-control form-control-sm"
                                , type_ "number"
                                , id "gearBox"
                                , Html.Attributes.min "1"
                                , Html.Attributes.max <| toString v.gear.max
                                , onInput (UpdateGear v)
                                , value <| toString v.gear.current
                                ]
                                []
                            ]
                        , label [ for "gearBox", class "col-form-label" ]
                            [ text <| "of " ++ toString v.gear.max ]
                        ]

        hazardTokens =
            if isPreview then
                text ""
            else
                div [ class "form-group form-row" ]
                    [ label [ for "hazardsGained", class "col-form-label" ]
                        [ text <| "Hazards Gained:" ]
                    , View.Utils.col ""
                        [ input
                            [ class "form-control form-control-sm"
                            , type_ "number"
                            , id "hazardsGained"
                            , Html.Attributes.min "0"
                            , Html.Attributes.max "6"
                            , onInput (UpdateHazards v)
                            , value <| toString v.hazards
                            ]
                            []
                        ]
                    , label [ for "hazardsGained", class "col-form-label" ]
                        [ text <| "of 6" ]
                    ]

        hullChecks =
            case (isPreview, wipedOut) of
                (True, _) ->
                    text <| "Hull Max: " ++ toString v.hull.max

                (_, True) ->
                    text ""

                (False, False) ->
                    div [ class "form-group form-row" ]
                        [ label [ for "hullInput", class "col-form-label" ]
                            [ text "Hull Dmg: " ]
                        , View.Utils.col ""
                            [ input
                                [ class "form-control form-control-sm"
                                , id "hullInput"
                                , type_ "number"
                                , onInput <| UpdateHull v
                                , value <| toString v.hull.current
                                , Html.Attributes.min "0"
                                , Html.Attributes.max <| toString v.hull.max
                                ]
                                []
                            ]
                        , label [ for "hullInput", class "col-form-label" ]
                            [ text <| "of " ++ toString v.hull.max ]
                        ]

        notes =
            div
                [ class "form-group form-row"
                , classList [ ("d-none", wipedOut) ]
                ]
                [ View.Utils.col ""
                    [ textarea
                        [ onInput (UpdateNotes isPreview v)
                        , class "form-control"
                        , placeholder "Notes"
                        ]
                        [ text v.notes ]
                    ]
                ]

        weaponsUsingSlots =
            List.sum <| List.map .slots v.weapons

        weaponList =
            View.Utils.detailSection
                currentView
                isPreview
                [ text "Weapon List"
                , small [ class "ml-2" ]
                    [ span
                        [ class "badge"
                        , classList
                            [ ( "badge-success", isCrewAvailable )
                            , ( "badge-danger", not isCrewAvailable )
                            ]
                        ]
                        [ text <| (toString <| View.Utils.crewUsed v) ++ "/" ++ (toString v.crew) ++ " crew used" ]
                    ]
                , small [ class "ml-2" ]
                    [ span [ class "badge badge-dark" ]
                        [ text <| (toString <| weaponsUsingSlots) ++ "/" ++ (toString v.crew) ++ " slots used" ]
                    ]
                , small []
                    [ button
                        [ onClick <| ToNewWeapon v
                        , class "btn btn-sm btn-outline-secondary ml-2"
                        ]
                        [ text "New Weapon" ]
                    ]
                ]
                (List.map (View.Weapon.render v) v.weapons)

        upgradeUsingSlots =
            List.sum <| List.map .slots v.upgrades

        upgradeList =
            View.Utils.detailSection
                currentView
                isPreview
                [ text "Upgrade List"
                , small [ class "ml-2" ]
                    [ span [ class "badge badge-dark" ]
                        [ text <| (toString <| upgradeUsingSlots) ++ "/" ++ (toString v.crew) ++ " slots used" ]
                    ]
                , small []
                    [ button
                        [ onClick <| ToNewUpgrade v
                        , class "btn btn-sm btn-outline-secondary ml-2"
                        ]
                        [ text "New Upgrade" ]
                    ]
                ]
                (List.map View.Upgrade.render v.upgrades)

        header =
            h4
                [ classList
                    [ ( "form-inline", isPreview )
                    , ( "card-title", currentView /= Details v )
                    ]
                ]
                [ activatedCheck
                , name
                , small []
                    [ vehicleType_, text <| " - " ++ weight ++ " (" ++ (toString <| vehicleCost v) ++ ")" ]
                ]

        body =
            div [ classList [ ( "card-text", currentView /= Details v ) ] ]
                [ gearBox
                , hazardTokens
                , hullChecks
                , div [ classList [ ("d-none", wipedOut) ] ]
                    [ text "Handling: "
                    , span [] [ text <| handling ]
                    ]
                , notes
                , weaponList
                , upgradeList
                ]

        footer =
            div
                [ class "buttons"
                , classList [ ( "d-none", wipedOut ) ]
                ]
                [ button
                    [ class "btn btn-sm btn-danger"
                    , classList [ ( "d-none", isPreview ) ]
                    , onClick <| DeleteVehicle v
                    ]
                    [ text "Delete" ]
                , button
                    [ class "btn btn-sm btn-secondary float-right"
                    , classList [ ( "d-none", currentView /= Overview || isPreview ) ]
                    , onClick <| ToDetails v
                    ]
                    [ text "Details" ]
                ]
            
    in
        case currentView of
            Details v ->
                div [] [ header, body ]

            _ ->
                View.Utils.card [ ("border-danger", wipedOut) ] header body footer
