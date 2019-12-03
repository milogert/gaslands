module View.Menu exposing (render)

import Bulma.Components exposing (..)
import Bulma.Elements exposing (..)
import Dict
import Html
    exposing
        ( Html
        , br
        , div
        , hr
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , classList
        , disabled
        , href
        , style
        )
import Html.Events
    exposing
        ( onClick
        )
import Model.Model exposing (..)
import Model.Routes exposing (Route(..))
import Model.Vehicle.Model exposing (..)
import View.Utils exposing (..)


render : Model -> List (Html Msg)
render model =
    let
        gameButtons =
            [ navbarItemLink
                False
                [ href "/" ]
                [ View.Utils.icon "home" ]
            , navbarItem
                False
                [ onClick <| VehicleMsg NextGearPhase ]
                [ View.Utils.icon "cogs"
                , easyTag tagModifiers
                    []
                    (String.fromInt model.gearPhase)
                ]
            ]

        detailsButtons =
            case model.view of
                RouteDetails key ->
                    let
                        vehicle =
                            model.vehicles
                                |> Dict.get key
                                |> Maybe.withDefault defaultVehicle

                        canActivate =
                            model.gearPhase <= vehicle.gear.current

                        activatedText =
                            case ( vehicle.activated, canActivate ) of
                                ( True, False ) ->
                                    "Activated"

                                ( _, False ) ->
                                    "Cannot be Activated"

                                ( _, _ ) ->
                                    "Activate"
                    in
                    [ button
                        buttonModifiers
                        [ onClick <| VehicleMsg <| UpdateActivated vehicle.key (not vehicle.activated)
                        , disabled <| not canActivate || vehicle.activated
                        ]
                        [ text activatedText ]
                    , navbarItemLink
                        False
                        [ href <| "/print/" ++ vehicle.key ]
                        [ View.Utils.icon "print" ]
                    ]

                _ ->
                    []

        settingsButtons =
            [ navbarItemLink
                False
                [ href "/new/vehicle" ]
                [ View.Utils.icon "plus" ]
            , navbarItemLink
                False
                [ disabled <| Dict.isEmpty model.vehicles
                , href "/print"
                ]
                [ View.Utils.icon "print" ]
            , navbarItemLink
                False
                [ attribute "aria-label" "Back Button"
                , href "/settings"
                ]
                [ View.Utils.icon "wrench" ]
            ]

        menuLayout : List (List (Html Msg)) -> List (Html Msg)
        menuLayout buttons =
            buttons
                |> List.filter (not << List.isEmpty)
                |> List.intersperse [ navbarDivider [] [] ]
                |> List.concat
    in
    [ gameButtons, detailsButtons, settingsButtons ]
        |> menuLayout
