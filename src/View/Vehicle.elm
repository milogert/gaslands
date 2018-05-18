module View.Vehicle exposing (render)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, max)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Upgrade
import View.Utils
import View.Weapon


render : CurrentView -> Bool -> Int -> Vehicle -> Html Msg
render currentView isPreview i v =
    let
        name =
            if isPreview then
                input
                    [ onInput TmpName
                    , placeholder "Name"
                    , class "form-control mr-3"
                    ]
                    [ text v.name ]
            else
                span [ class "mr-3" ] [ text v.name ]

        vtype =
            vTToStr v.vtype

        vehicleType_ =
            if isPreview then
                select
                    [ onInput TmpVehicleType
                    , class "form-control"
                    ]
                    (option [ value "" ] [ text "Vehicle Type" ]
                        :: List.map
                            (\x ->
                                option
                                    [ value <| vTToStr x ]
                                    [ text <| vTToStr x ]
                            )
                            allVehicleTypes
                    )
            else
                text <| vtype

        weight =
            toString v.weight

        handling =
            toString v.handling

        gearUsed =
            List.sum (List.map .slots v.weapons)

        gearRemaining =
            toString <| v.gear - gearUsed

        crewRemaining =
            toString <| v.crew - View.Utils.crewUsed v

        activatedCheck =
            div
                [ classList [ ( "d-none", isPreview ) ]
                , class "form-check"
                ]
                [ input
                    [ class "form-check-input"
                    , type_ "checkbox"
                    , onClick (UpdateActivated i v (not v.activated))
                    , id ("activateCheck" ++ v.name)
                    , checked v.activated
                    , disabled isPreview
                    ]
                    []
                , label
                    [ class "form-check-label"
                    , for ("activateCheck" ++ v.name)
                    ]
                    [ text "Activated" ]
                ]

        hullChecks =
            if isPreview then
                text <| "Hull Max: " ++ toString v.hull.max
            else
                div [ class "form-group form-row" ]
                    [ label [ for "hullInput", class "col-6 col-form-label" ]
                        [ text <| "Hull Damage (max: " ++ (toString v.hull.max) ++ "): "]
                    , div [ class "col-6" ]
                        [ input
                            [ class "form-control form-control-sm"
                            , id "hullInput"
                            , type_ "number"
                            , onInput <| UpdateHull i v
                            , value <| toString v.hull.current
                            , Html.Attributes.min "0"
                            , Html.Attributes.max <| toString v.hull.max
                            ]
                            []
                        ]
                    ]

        notes =
            div [ class "form-group form-row" ]
                [ textarea
                    [ onInput (UpdateNotes isPreview i v)
                    , class "form-control"
                    , placeholder "Notes"
                    ]
                    [ text v.notes ]
                ]

        weaponList =
            View.Utils.detailSection
                currentView
                isPreview
                [ text "Weapon List"
                , small []
                    [ button
                        [ onClick <| ToNewWeapon i v
                        , class "btn btn-sm btn-outline-secondary float-right"
                        ]
                        [ text "+" ]
                    ]
                ]
                (List.map View.Weapon.render v.weapons)

        upgradeList =
            View.Utils.detailSection
                currentView
                isPreview
                [ text "Upgrade List"
                , small []
                    [ button
                        [ onClick <| ToNewUpgrade i v
                        , class "btn btn-sm btn-outline-secondary float-right"
                        ]
                        [ text "+" ]
                    ]
                ]
                (List.map View.Upgrade.render v.upgrades)

        header =
            h4
                [ classList
                    [ ( "form-inline", isPreview )
                    , ( "card-title", currentView /= Details i v )
                    ]
                ]
                [ name
                , small []
                    [ vehicleType_, text <| " - " ++ weight ++ " (" ++ (toString <| vehicleCost v) ++ ")" ]
                ]

        body =
            div [ classList [ ( "card-text", currentView /= Details i v ) ] ]
                [ activatedCheck
                , hullChecks
                , div []
                    [ text "Handling: "
                    , span [] [ text <| handling ]
                    ]
                , div []
                    [ text "Gear slots remaining: "
                    , span [] [ text <| gearRemaining ]
                    ]
                , div []
                    [ text "Crew slots remaining: "
                    , span [] [ text <| crewRemaining ]
                    ]
                , notes
                , weaponList
                , upgradeList
                , div [ class "buttons" ]
                    [ button
                        [ class "btn btn-sm btn-danger"
                        , classList [("d-none", isPreview)]
                        , onClick <| DeleteVehicle i
                        ]
                        [ text "Delete" ]
                    , button
                        [ class "btn btn-sm btn-secondary float-right"
                        , classList [ ( "d-none", currentView /= Overview || isPreview ) ]
                        , onClick <| ToDetails i v
                        ]
                        [ text "Details" ]
                    ]
                ]
    in
    case currentView of
        Details i v ->
            div [] [ header, body ]

        _ ->
            View.Utils.card header body
