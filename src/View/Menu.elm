module View.Menu exposing (side, top)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text
import Bootstrap.Utilities.Spacing as Spacing
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
        , style
        )
import Model.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Utils exposing (..)


type MenuLocation
    = Side
    | Top


side : Model -> Grid.Column Msg
side model =
    renderInternal model Side


top : Model -> Grid.Column Msg
top model =
    renderInternal model Top


renderInternal : Model -> MenuLocation -> Grid.Column Msg
renderInternal model location =
    let
        buttonSize =
            case location of
                Side ->
                    [ Button.block ]

                Top ->
                    []

        allButtonConfig =
            buttonSize
                ++ [ Button.small ]

        gameButtons =
            [ Button.button
                ((++)
                    allButtonConfig
                    [ Button.primary
                    , Button.onClick <| To ViewDashboard
                    ]
                )
                [ icon "home" ]
            , Button.button
                ((++)
                    allButtonConfig
                    [ Button.primary
                    , Button.onClick <| VehicleMsg NextGearPhase
                    ]
                )
                [ icon "cogs"
                , Badge.badgeLight []
                    [ text <|
                        String.fromInt model.gearPhase
                    ]
                ]
            ]

        detailsButtons =
            case model.view of
                ViewDetails vehicle ->
                    let
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
                    [ Button.button
                        ((++)
                            allButtonConfig
                            [ Button.primary
                            , Button.onClick <| VehicleMsg <| UpdateActivated vehicle.key (not vehicle.activated)
                            , Button.disabled <| not canActivate || vehicle.activated
                            ]
                        )
                        [ text activatedText ]
                    , Button.button
                        ((++)
                            allButtonConfig
                            [ Button.secondary
                            , Button.onClick <| To <| ViewPrinterFriendly [ vehicle ]
                            ]
                        )
                        [ icon "print" ]
                    ]

                _ ->
                    []

        settingsButtons =
            [ Button.button
                ((++)
                    allButtonConfig
                    [ Button.primary
                    , Button.onClick <| ShowModal "vehicle"
                    ]
                )
                [ icon "plus", icon "car" ]
            , Button.button
                ((++)
                    allButtonConfig
                    [ Button.secondary
                    , Button.onClick <| To <| ViewPrinterFriendly <| Dict.values model.vehicles
                    ]
                )
                [ icon "print", icon "car" ]
            , Button.button
                ((++)
                    allButtonConfig
                    [ Button.light
                    , Button.onClick <| ShowModal "settings"
                    , Button.attrs
                        [ attribute "aria-label" "Back Button"
                        ]
                    ]
                )
                [ icon "wrench" ]
            ]

        menuLayout : List (List (Html Msg)) -> List (Html Msg)
        menuLayout buttons =
            case location of
                Side ->
                    buttons
                        |> List.map (List.intersperse (div [ Spacing.pb2 ] []))
                        |> List.filter (not << List.isEmpty)
                        |> List.map (div [])
                        |> List.intersperse (hr [] [])

                Top ->
                    buttons
                        |> List.map (List.intersperse (span [ Spacing.pl2 ] []))
                        |> List.filter (not << List.isEmpty)
                        |> List.map (span [])
                        |> List.intersperse (span [ Spacing.mx2, style "border-left" "1px solid rgba(0,0,0,.1)" ] [])

        colSize =
            case location of
                Side ->
                    Col.xsAuto

                Top ->
                    Col.xs12

        colAlignment =
            case location of
                Side ->
                    Text.alignXsCenter

                Top ->
                    Text.alignXsLeft

        displayClasses =
            case location of
                Side ->
                    [ "side-menu", "d-none", "d-md-block" ]

                Top ->
                    [ "top-menu", "d-md-none" ]
    in
    [ gameButtons, detailsButtons, settingsButtons ]
        |> menuLayout
        |> Grid.col
            [ colSize
            , Col.textAlign colAlignment
            , Col.attrs
                [ class "menu"
                , classList <| List.map (\c -> ( c, True )) <| displayClasses
                ]
            ]
