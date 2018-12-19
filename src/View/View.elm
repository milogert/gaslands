module View.View exposing (view)

import Browser exposing (Document)
import Html exposing (Html, a, button, div, form, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (attribute, checked, class, classList, disabled, for, href, id, max, min, placeholder, readonly, rel, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Details
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.Overview
import View.Settings
import View.Sponsor
import View.SponsorSelect
import View.Utils exposing (..)


view : Model -> Document Msg
view model =
    let
        viewToGoTo =
            case model.view of
                Details _ ->
                    ToOverview

                SelectingSponsor ->
                    ToOverview

                AddingVehicle ->
                    ToOverview

                AddingWeapon v ->
                    ToDetails v

                AddingUpgrade v ->
                    ToDetails v

                Settings ->
                    ToOverview

                Overview ->
                    ToOverview

        backButton =
            button
                [ disabled <| model.view == Overview
                , class "btn btn-light btn-sm btn-block"
                , onClick viewToGoTo
                , attribute "aria-label" "Back Button"
                ]
                [ icon "arrow-left" ]

        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        gearPhaseText =
            String.fromInt model.gearPhase

        teamName =
            case model.teamName of
                Nothing ->
                    ""

                Just s ->
                    s

        viewDisplay =
            h2 [ style "margin-bottom" "0" ]
                [ text <| viewToStr model ]
    in
    Document
        (viewToStr model)
        [ div [ class "container" ]
            [ View.Utils.rowPlus [ "mt-2", "mb-2" ]
                [ View.Utils.colPlus [ "auto" ]
                    [ "my-auto" ]
                    [ backButton ]
                , View.Utils.colPlus []
                    [ "my-auto", "col" ]
                    [ viewDisplay ]
                , View.Utils.colPlus [ "12", "md-auto" ]
                    [ "form-inline", "col", "mb-auto", "mt-1", "mt-md-auto" ]
                    [ span [ class "mr-2" ]
                        [ View.Sponsor.renderBadge model.sponsor ]
                    , button
                        [ class "btn btn-sm btn-primary mr-2"
                        , value <| String.fromInt model.gearPhase
                        , onClick NextGearPhase
                        ]
                        [ icon "cogs", span [ class "badge badge-light" ] [ text gearPhaseText ] ]
                    , span
                        [ class "badge mr-2"
                        , classList
                            [ ( "badge-danger", currentPoints > maxPoints )
                            , ( "badge-success", currentPoints == maxPoints )
                            , ( "badge-warning", currentPoints < maxPoints )
                            ]
                        ]
                        [ text <| String.fromInt currentPoints ++ " of " ++ String.fromInt maxPoints
                        , icon "coins"
                        ]
                    , button
                        [ class "btn btn-sm btn-light"
                        , onClick ToSettings
                        , attribute "aria-label" "Back Button"
                        ]
                        [ icon "wrench" ]
                    ]
                ]
            , hr [] []
            , displayAlert model
            , render model

            --, sizeShower
            ]
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
                        row
                            [ div
                                [ class "col alert alert-danger" ]
                                [ text <| errorToStr x ]
                            ]
                    )
                    model.error


render : Model -> Html Msg
render model =
    case model.view of
        Overview ->
            View.Overview.view model

        Details v ->
            View.Details.view model v

        SelectingSponsor ->
            View.SponsorSelect.view model

        AddingVehicle ->
            View.NewVehicle.view model

        AddingWeapon v ->
            View.NewWeapon.view model v

        AddingUpgrade v ->
            View.NewUpgrade.view model v

        Settings ->
            View.Settings.view model


sizeShower : Html Msg
sizeShower =
    div []
        [ span
            [ class "d-sm-none d-md-none d-lg-none d-xl-none" ]
            [ text "xs" ]
        , span
            [ class "d-sm-inline d-md-none d-lg-none d-xl-none" ]
            [ text "sm" ]
        , span
            [ class "d-sm-none d-md-inline d-lg-none d-xl-none" ]
            [ text "md" ]
        , span
            [ class "d-sm-none d-md-none d-lg-inline d-xl-none" ]
            [ text "lg" ]
        , span
            [ class "d-sm-none d-md-none d-lg-none d-xl-inline" ]
            [ text "xl" ]
        ]
