module View.View exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul, form)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, readonly)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import View.Details
import View.NewUpgrade
import View.NewVehicle
import View.NewWeapon
import View.Overview


view : Model -> Html Msg
view model =
    let
        toOverview =
            button
                [ classList [ ( "d-none", model.view == Overview ) ]
                , class "btn btn-default mr-3"
                , onClick ToOverview
                ]
                [ text "<" ]
    in
    div [ class "container" ]
        [ div [ class "row" ]
            [ h2 [ class "col mt-3" ]
                [ toOverview
                , text "Gaslands Manager "
                , small [] [ text <| viewToStr model.view ]
                ]
            , form [ class "col-md-3 col-sm-12 my-auto" ]
                [ div [ class "form-row" ]
                    [ div [ class "col-4" ]
                        [ input
                            [ type_ "text"
                            , readonly True
                            , class "form-control-plaintext"
                            , value <| (toString <| totalPoints model) ++ " of"
                            ]
                            []
                        ]
                    , div [ class "col-8" ]
                        [ input
                            [ type_ "number"
                            , class "form-control form-control-sm my-1"
                            , value <| toString model.pointsAllowed
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
        "" ->
            text ""

        _ ->
            div [ class "row" ]
                [ div
                    [ class "col alert alert-danger" ]
                    [ text model.error ]
                ]


render : Model -> Html Msg
render model =
    case model.view of
        Overview ->
            View.Overview.view model

        Details i v ->
            View.Details.view i v

        AddingVehicle ->
            View.NewVehicle.view model

        AddingWeapon i v ->
            View.NewWeapon.view model i v

        AddingUpgrade i v ->
            View.NewUpgrade.view model i v
