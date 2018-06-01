module View.View exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul, form, a)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, readonly)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Details
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.Overview
import View.Utils exposing (..)


view : Model -> Html Msg
view model =
    let
        viewToGoTo =
            case model.view of
                Details _ ->
                    ToOverview

                AddingVehicle ->
                    ToOverview

                AddingWeapon v ->
                    ToDetails v

                AddingUpgrade v ->
                    ToDetails v

                Overview ->
                    ToOverview

        backButton =
            button
                [ classList [ ( "d-none", model.view == Overview ) ]
                , class "btn btn-default mr-3"
                , onClick viewToGoTo
                ]
                [ text "<" ]

        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        gearPhaseText =
            "Gear Phase: " ++ (toString model.gearPhase)
    in
        div [ class "container" ]
            [ row
                [ h2 [ class "col mt-3" ]
                    [ backButton
                    , text <| viewToStr model.view
                    ]
                , View.Utils.colPlus [ "lg-2", "md-3", "sm-12" ]
                    [ "my-auto" ]
                    [ button
                        [ class "btn btn-sm btn-primary"
                        , value <| toString model.gearPhase
                        , onClick NextGearPhase
                        ]
                        [ text gearPhaseText ]
                    ]
                , div [ class "col-lg-2 col-md-3 col-sm-12 my-auto" ]
                    [ div [ class "form-group form-row mb-0" ]
                        [ label
                            [ for "squadPoints"
                            , class "col-form-label"
                            ]
                            [ text <| (toString <| currentPoints) ++ " of" ]
                        , col ""
                            [ input
                                [ type_ "number"
                                , class "form-control form-control-sm my-1"
                                , classList
                                    [ ( "above-points", currentPoints > maxPoints )
                                    , ( "at-points", currentPoints == maxPoints )
                                    , ( "below-points", currentPoints < maxPoints )
                                    ]
                                , id "squadPoints"
                                , value <| toString maxPoints
                                , onInput UpdatePointsAllowed
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            , hr [] []
            , displayAlert model
            , render model
            ]


displayAlert : Model -> Html Msg
displayAlert model =
    case model.error of
        [] ->
            text ""

        _ ->
            div [] <|
                List.map
                    (\x ->
                        (row
                            [ div
                                [ class "col alert alert-danger" ]
                                [ text <| errorToStr x ]
                            ]
                        )
                    )
                    model.error


render : Model -> Html Msg
render model =
    case model.view of
        Overview ->
            View.Overview.view model

        Details v ->
            View.Details.view model v

        AddingVehicle ->
            View.NewVehicle.view model

        AddingWeapon v ->
            View.NewWeapon.view model v

        AddingUpgrade v ->
            View.NewUpgrade.view model v
