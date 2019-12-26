module View.Menu exposing (brand, end, start)

import Bulma.Components exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Dict
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Solid as Icon
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
        , style
        )
import Html.Events
    exposing
        ( onClick
        )
import Model.Features
import Model.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Views exposing (NewType(..), ViewEvent(..))
import View.Sponsor
import View.Utils exposing (..)


brand : Model -> NavbarSection Msg
brand model =
    let
        burger =
            navbarBurger model.navOpen
                [ onClick <| NavToggle <| not model.navOpen ]
                [ span [] [], span [] [], span [] [] ]
    in
    navbarBrand []
        burger
        [ navbarItemLink False
            [ onClick <| ViewMsg ViewDashboard ]
            [ text <| "Team " ++ Maybe.withDefault "NoName" model.teamName ]
        , navbarItem
            False
            [ onClick <| VehicleMsg NextGearPhase ]
            [ Icon.cogs |> Icon.viewIcon
            , easyTag tagModifiers
                []
                (String.fromInt model.gearPhase)
            ]
        ]


start : Model -> NavbarSection Msg
start model =
    let
        detailsButtons =
            case model.view of
                ViewDetails key ->
                    let
                        vehicle =
                            model.vehicles
                                |> Dict.get key
                                |> Maybe.withDefault defaultVehicle

                        canActivate =
                            model.gearPhase <= vehicle.gear.current

                        activatedText =
                            case ( vehicle.activated, canActivate ) of
                                ( True, _ ) ->
                                    "Activated"

                                ( _, False ) ->
                                    "Cannot be Activated"

                                ( _, _ ) ->
                                    "Activate"
                    in
                    [ navbarItem False
                        []
                        [ controlButton buttonModifiers
                            []
                            [ onClick <| VehicleMsg <| UpdateActivated vehicle.key (not vehicle.activated)
                            , disabled <| not canActivate || vehicle.activated
                            ]
                            [ text activatedText ]
                        ]
                    , navbarItemLink False
                        [ onClick <| ViewMsg <| ViewPrint vehicle.key ]
                        [ Icon.print |> Icon.viewIcon ]
                        |> Model.Features.withDefault "feature-printing" (text "")
                    ]

                _ ->
                    []
    in
    [ detailsButtons ]
        |> menuLayout
        |> navbarStart []


end : Model -> NavbarSide Msg
end model =
    let
        currentPoints =
            totalPoints model

        maxPoints =
            model.pointsAllowed

        pointsColor =
            case compare currentPoints maxPoints of
                LT ->
                    Warning

                EQ ->
                    Success

                GT ->
                    Danger

        pointsBadge =
            navbarItem False
                []
                [ tag
                    { tagModifiers | color = pointsColor }
                    [ class "ml-2" ]
                    [ text <| String.fromInt currentPoints ++ " of " ++ String.fromInt maxPoints
                    , View.Utils.icon "coins"
                    ]
                ]

        settingsButtons =
            [ navbarItemLink
                False
                [ onClick <| ViewMsg <| ViewNew NewVehicle ]
                [ Icon.plus |> Icon.viewStyled [ style "margin-right" ".5rem" ]
                , text "New Vehicle"
                ]
            , navbarItemLink
                False
                [ disabled <| Dict.isEmpty model.vehicles
                , onClick <| ViewMsg ViewPrintAll
                ]
                [ Icon.print |> Icon.viewIcon ]
                |> Model.Features.withDefault "feature-printing" (text "")
            , navbarItem False
                []
                [ View.Sponsor.renderBadge model.sponsor ]
            , pointsBadge
            , navbarItemLink
                False
                [ attribute "aria-label" "Back Button"
                , onClick <| ViewMsg ViewSettings
                ]
                [ Icon.wrench |> Icon.viewIcon ]
            ]
    in
    [ settingsButtons ]
        |> menuLayout
        |> navbarEnd []


menuLayout : List (List (Html Msg)) -> List (Html Msg)
menuLayout buttons =
    buttons
        |> List.filter (not << List.isEmpty)
        |> List.intersperse [ navbarDivider [] [] ]
        |> List.concat
