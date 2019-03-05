module View.New exposing (view)

import Bootstrap.Button as Btn
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, text)
import Html.Attributes exposing (class, size, value)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Upgrade


view :
    Model
    -> Vehicle
    -> Maybe a
    -> (String -> a -> Msg)
    -> (Model -> Vehicle -> a -> Html Msg)
    -> List { a | slots : Int, expansion : Expansion, name : String }
    -> (String -> Msg)
    -> Html Msg
view model vehicle mThing buttonMsg renderFunc filteredThings selectMsg =
    let
        buttonAttrs =
            [ Btn.primary
            , Btn.attrs [ class "mb-3" ]
            ]

        addButton =
            case mThing of
                Just thing ->
                    Btn.button
                        (Btn.onClick (buttonMsg vehicle.key thing) :: buttonAttrs)
                        [ text "Add" ]

                Nothing ->
                    Btn.button
                        (Btn.disabled True :: buttonAttrs)
                        [ text "Choose" ]

        body =
            case mThing of
                Just thing ->
                    renderFunc model vehicle thing

                Nothing ->
                    text "Select from dropdown."

        thingToTuple t =
            ( t.name, fromExpansionAbbrev t.expansion )

        options =
            filteredThings
                |> List.map thingToTuple
                |> List.map
                    (\( name, exp ) ->
                        Select.item
                            [ value name ]
                            [ text <| name ++ " (" ++ exp ++ ")" ]
                    )

        selectList =
            Select.select
                [ Select.onChange selectMsg
                , Select.attrs
                    [ class "mb-3"
                    , size 8
                    ]
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md3 ] [ addButton, selectList ]
        , Grid.col [ Col.md9 ] [ body ]
        ]
