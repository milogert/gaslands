module View.NewUpgrade exposing (view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html exposing (Html, div, hr, option, text)
import Html.Attributes exposing (class, disabled, size, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Model exposing (..)
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
                    controlButton buttonModifiers
                        []
                        [ disabled True ]
                        [ text "Choose Upgrade Type" ]

        body =
            case model.tmpUpgrade of
                Just weapon ->
                    View.Upgrade.render
                        (View.Upgrade.RenderConfig
                            True
                            False
                            False
                        )
                        model
                        vehicle
                        weapon

                Nothing ->
                    text "Select an upgrade type from the dropdown."

        thingToTuple : Upgrade -> ( String, String )
        thingToTuple t =
            ( t.name, fromExpansionAbbrev t.expansion )

        options =
            weapons
                |> List.map thingToTuple
                |> List.map
                    (\( name, exp ) ->
                        option
                            [ value name ]
                            [ text <| name ++ " (" ++ exp ++ ")" ]
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
