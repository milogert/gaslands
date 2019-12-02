module View.NewWeapon exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, div, hr, text)
import Html.Attributes exposing (class, disabled, size, value)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)
import View.Weapon exposing (defaultWeaponConfig)


view : Model -> Vehicle -> List Weapon -> Html Msg
view model vehicle weapons =
    let
        buttonAttrs =
            [ Button.primary
            , Button.attrs [ class "mb-3" ]
            ]

        addButton =
            case model.tmpWeapon of
                Just weapon ->
                    case weapon.mountPoint of
                        Nothing ->
                            Button.button
                                (Button.disabled True :: buttonAttrs)
                                [ text "Select Mount Point" ]

                        Just _ ->
                            Button.button
                                (Button.onClick (WeaponMsg <| AddWeapon vehicle.key weapon) :: buttonAttrs)
                                [ text <| "Add " ++ weapon.name ++ " to " ++ vehicle.name ]

                Nothing ->
                    Button.button
                        (Button.disabled True :: buttonAttrs)
                        [ text "Choose Weapon Type" ]

        body =
            case model.tmpWeapon of
                Just weapon ->
                    View.Weapon.render
                        { defaultWeaponConfig
                            | showFireButton = False
                            , printSpecials = False
                            , showDeleteButton = False
                        }
                        model
                        vehicle
                        weapon

                Nothing ->
                    text "Select a weapon type from the dropdown."

        thingToTuple : Weapon -> ( String, String )
        thingToTuple t =
            ( t.name, fromExpansionAbbrev t.expansion )

        options =
            weapons
                |> List.map thingToTuple
                |> List.map
                    (\( name, exp ) ->
                        Select.item
                            [ value name ]
                            [ text <| name ++ " (" ++ exp ++ ")" ]
                    )
                |> (::) (Select.item [] [ text "" ])

        selectList =
            Select.select
                [ Select.onChange (WeaponMsg << TmpWeaponUpdate)
                , Select.attrs
                    [ class "mb-3"
                    ]
                ]
                options

        mountPointOption mountPoint =
            mountPoint
                |> fromWeaponMounting
                |> (\mp -> Select.item [ value mp ] [ text mp ])

        mountPointSelector =
            case model.tmpWeapon of
                Nothing ->
                    Select.select
                        [ Select.attrs [ disabled True ] ]
                        [ Select.item
                            [ value "" ]
                            [ text "Select a weapon type above" ]
                        ]

                Just weapon ->
                    case Just CrewFired == weapon.mountPoint of
                        True ->
                            Select.select
                                [ Select.attrs [ disabled True ] ]
                                [ Select.item
                                    [ value "" ]
                                    [ text "Crew Fired" ]
                                ]

                        False ->
                            [ Full, Front, LeftSide, RightSide, Rear ]
                                |> List.map mountPointOption
                                |> (::) (Select.item [ value "" ] [ text "" ])
                                |> Select.select
                                    [ Select.onChange <| WeaponMsg << TmpWeaponMountPoint
                                    ]
    in
    Grid.row []
        [ Grid.col [ Col.md12 ]
            [ Form.form []
                [ Form.row []
                    [ Form.colLabel [ Col.mdAuto ]
                        [ Form.label [] [ text "Weapon Type" ] ]
                    , Form.col [] [ selectList ]
                    ]
                , Form.row []
                    [ Form.colLabel [ Col.mdAuto ]
                        [ Form.label [] [ text "Mount Point" ] ]
                    , Form.col [] [ mountPointSelector ]
                    ]
                ]
            ]
        , Grid.col [ Col.md12 ] [ body ]
        , Grid.col [ Col.md12 ]
            [ addButton
            ]
        ]
