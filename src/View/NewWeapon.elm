module View.NewWeapon exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (Html, text)
import Html.Attributes exposing (class, size, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Common exposing (..)
import View.Utils
import View.Weapon


view : Model -> Vehicle -> Html Msg
view model v =
    let
        addButton =
            case model.tmpWeapon of
                Just w ->
                    Button.button
                        [ Button.primary
                        , Button.attrs [ class "mb-3" ]
                        , Button.onClick (AddWeapon v.key w)
                        ]
                        [ text "Add Weapon" ]

                Nothing ->
                    Button.button
                        [ Button.primary
                        , Button.attrs [ class "mb-3" ]
                        , Button.disabled True
                        ]
                        [ text "Select Weapon" ]

        body =
            case model.tmpWeapon of
                Just tmpWeapon ->
                    View.Weapon.render model v tmpWeapon

                Nothing ->
                    text "Select a weapon."

        options =
            allWeaponsList
                |> List.filter
                    (\x -> x.slots <= slotsRemaining v)
                |> List.filter (\x -> x.name /= handgun.name)
                |> List.filter (View.Utils.weaponSponsorFilter model)
                |> List.map
                    (\w ->
                        ( w.name, fromExpansionAbbrev w.expansion )
                    )
                |> List.map
                    (\( name, exp ) ->
                        Select.item
                            [ value name ]
                            [ text <| name ++ " (" ++ exp ++ ")" ]
                    )

        selectList =
            Select.select
                [ Select.onChange TmpWeaponUpdate
                , Select.attrs
                    [ class "form-control mb-3"
                    , size 8
                    ]
                ]
                options
    in
    Grid.row []
        [ Grid.col [ Col.md3 ] [ addButton, selectList ]
        , Grid.col [ Col.md9 ] [ body ]
        ]
