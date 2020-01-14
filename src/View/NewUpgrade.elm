module View.NewUpgrade exposing (view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html exposing (Html, div, option, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Vehicle exposing (..)
import View.Upgrade


view : Model -> Vehicle -> List Upgrade -> Html Msg
view model vehicle weapons =
    let
        addButton =
            case model.tmpUpgrade of
                Just upgrade ->
                    controlButton buttonModifiers
                        []
                        [ onClick (UpgradeMsg <| AddUpgrade vehicle.key upgrade) ]
                        [ text <| "Add " ++ upgrade.name ++ " to " ++ vehicle.name ]

                Nothing ->
                    controlButton { buttonModifiers | disabled = True }
                        []
                        []
                        [ text "Choose Upgrade Type" ]

        body =
            case model.tmpUpgrade of
                Just weapon ->
                    View.Upgrade.render
                        (View.Upgrade.RenderConfig
                            True
                            False
                            False
                            False
                        )
                        model
                        vehicle
                        weapon

                Nothing ->
                    text "Select an upgrade type from the dropdown."

        options =
            weapons
                |> List.map
                    (\upgrade ->
                        option
                            [ value upgrade.name ]
                            [ text <| upgrade.name ]
                    )
                |> (::) (option [] [ text "" ])

        selectList =
            controlSelect controlSelectModifiers
                []
                [ onInput (UpgradeMsg << TmpUpgradeUpdate) ]
                options
    in
    div []
        [ horizontalFields []
            [ fieldLabel Standard
                []
                [ controlLabel [] [ text "Upgrade Type" ] ]
            , fieldBody [] [ selectList ]
            ]
        , horizontalFields []
            [ fieldLabel Standard [] []
            , fieldBody [] [ addButton ]
            ]
        , box [] [ body ]
        ]
