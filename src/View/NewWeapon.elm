module View.NewWeapon exposing (view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html exposing (Html, div, option, text)
import Html.Attributes exposing (disabled, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)
import View.Weapon exposing (defaultWeaponConfig)


view : Model -> Vehicle -> List Weapon -> Html Msg
view model vehicle weapons =
    let
        addButton =
            case model.tmpWeapon of
                Just weapon ->
                    case weapon.mountPoint of
                        Nothing ->
                            controlButton
                                { buttonModifiers
                                    | disabled = True
                                }
                                []
                                []
                                [ text "Select Mount Point" ]

                        Just _ ->
                            controlButton buttonModifiers
                                []
                                [ onClick (WeaponMsg <| AddWeapon vehicle.key weapon) ]
                                [ text <| "Add " ++ weapon.name ++ " to " ++ vehicle.name ]

                Nothing ->
                    controlButton
                        { buttonModifiers
                            | disabled = True
                        }
                        []
                        []
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

        options =
            weapons
                |> List.map
                    (\weapon ->
                        option
                            [ value weapon.name ]
                            [ text <| weapon.name ]
                    )
                |> (::) (option [] [ text "" ])

        selectList =
            controlSelect controlSelectModifiers
                []
                [ onInput (WeaponMsg << TmpWeaponUpdate) ]
                options

        mountPointOption mountPoint =
            mountPoint
                |> fromWeaponMounting
                |> (\mp -> option [ value mp ] [ text mp ])

        mountPointSelector =
            case model.tmpWeapon of
                Nothing ->
                    controlSelect controlSelectModifiers
                        []
                        [ disabled True ]
                        [ option
                            [ value "" ]
                            [ text "Select a weapon type above" ]
                        ]

                Just weapon ->
                    case Just CrewFired == weapon.mountPoint of
                        True ->
                            controlSelect controlSelectModifiers
                                []
                                [ disabled True ]
                                [ option
                                    [ value "" ]
                                    [ text "Crew Fired" ]
                                ]

                        False ->
                            [ Full, Front, LeftSide, RightSide, Rear ]
                                |> List.map mountPointOption
                                |> (::) (option [ value "" ] [ text "" ])
                                |> controlSelect controlSelectModifiers
                                    []
                                    [ onInput <| WeaponMsg << TmpWeaponMountPoint
                                    ]
    in
    div []
        [ horizontalFields []
            [ fieldLabel Standard
                []
                [ controlLabel [] [ text "Weapon Type" ] ]
            , fieldBody [] [ selectList ]
            ]
        , horizontalFields []
            [ fieldLabel Standard
                []
                [ controlLabel [] [ text "Mount Point" ] ]
            , fieldBody [] [ mountPointSelector ]
            ]
        , horizontalFields []
            [ fieldLabel Standard [] []
            , fieldBody [] [ addButton ]
            ]
        , box [] [ body ]
        ]
