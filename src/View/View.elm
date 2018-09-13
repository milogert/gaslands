module View.View exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul, form, a)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, readonly, style)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Details
import View.Settings
import View.Sponsor
import View.SponsorSelect
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
                [ -- classList [ ( "d-none", model.view == Overview ) ]
                  disabled <| model.view == Overview
                , class "btn btn-light btn-sm btn-block"
                , onClick viewToGoTo
                ]
                [ icon "arrow-left" ]

        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        gearPhaseText =
            (toString model.gearPhase)

        teamName =
            case model.teamName of
                Nothing ->
                    ""

                Just s ->
                    s

        viewDisplay =
            case model.view of
                Overview ->
                    input
                        [ class "form-control form-control-lg"
                        , classList [ ( "d-none", not <| model.view == Overview ) ]
                        , type_ "text"
                        , onInput UpdateTeamName
                        , value teamName
                        , placeholder "Team Name"
                        ]
                        []

                _ ->
                    h2 [ style [ ( "margin-bottom", "0" ) ] ]
                        [ text <| viewToStr model.view ]
    in
        div [ class "container" ]
            [ View.Utils.rowPlus [ "mt-2", "mb-2" ]
                [ View.Utils.colPlus [ "auto" ]
                    [ "my-auto" ]
                    [ backButton ]
                , View.Utils.colPlus []
                    [ "my-auto", "col" ]
                    [ viewDisplay ]
                , View.Utils.colPlus [ "auto" ]
                    [ "my-auto" ]
                    [ View.Sponsor.renderBadge model.sponsor ]
                , View.Utils.colPlus [ "12", "md-auto" ]
                    [ "my-auto", "form-inline", "col" ]
                    [ button
                        [ class "btn btn-sm btn-primary mr-2"
                        , value <| toString model.gearPhase
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
                        [ text <| (toString currentPoints) ++ " of " ++ toString maxPoints ++ " points"
                        ]
                    , button
                        [ class "btn btn-sm btn-light", onClick ToSettings ]
                        [ icon "wrench" ]
                    ]
                ]
            , displayAlert model
            , render model

            --, sizeShower
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
