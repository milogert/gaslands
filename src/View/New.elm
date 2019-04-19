module View.New exposing (view)

import Bootstrap.Button as Btn
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, hr, text)
import Html.Attributes exposing (class, size, value)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import View.Upgrade
import View.Utils exposing (NewItem)


view :
    Model
    -> Vehicle
    -> Maybe a
    -> (event -> Msg)
    -> (String -> a -> event)
    -> (Model -> Vehicle -> a -> Html Msg)
    -> List { a | slots : Int, expansion : Expansion, name : String }
    -> (String -> Msg)
    -> NewItem
view model vehicle mThing msg event renderFunc filteredThings selectMsg =
    let
        buttonAttrs =
            [ Btn.primary
            , Btn.attrs [ class "mb-3" ]
            ]

        addButton =
            case mThing of
                Just thing ->
                    Btn.button
                        (Btn.onClick (msg <| event vehicle.key thing) :: buttonAttrs)
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
                |> (::) (Select.item [] [ text "" ])

        selectList =
            Select.select
                [ Select.onChange selectMsg
                , Select.attrs
                    [ class "mb-3"
                    ]
                ]
                options
    in
    NewItem
        (Grid.row []
            [ Grid.col [ Col.md12 ] [ selectList ]
            , Grid.col [ Col.md12 ] [ hr [] [] ]
            , Grid.col [ Col.md12 ] [ body ]
            ]
        )
        addButton
