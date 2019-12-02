module View.EquipmentLayout exposing (render)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Html
    exposing
        ( Html
        , a
        , h6
        , small
        , text
        )
import Html.Attributes exposing (hidden, style)
import Html.Events exposing (onClick)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import View.Utils exposing (icon)


render :
    { a | name : String, expansion : Expansion, specials : List Special }
    -> Maybe ({ a | name : String, expansion : Expansion, specials : List Special } -> Msg)
    -> List (Html Msg)
    -> List (Html Msg)
    -> Html Msg
render thing mRemoveMsg leftCol rightCol =
    let
        deleteButton =
            case mRemoveMsg of
                Nothing ->
                    text ""

                Just removeMsg ->
                    a
                        [ onClick <| removeMsg thing
                        , style "cursor" "pointer"
                        ]
                        [ icon "times" ]
    in
    Grid.row
        [ Row.middleXs, Row.topMd ]
        [ Grid.col [ Col.xs12 ]
            [ h6 []
                [ text ""
                , text <| thing.name ++ " "
                , small []
                    [ text <| Model.Shared.fromExpansion thing.expansion ]
                ]
            ]
        , Grid.col [ Col.xs12 ]
            [ Grid.simpleRow
                [ Grid.col [ Col.md2, Col.xs4 ]
                    leftCol
                , Grid.col
                    [ Col.md10
                    , Col.xs8
                    , Col.attrs [ hidden <| List.length thing.specials == 0 ]
                    ]
                    rightCol
                ]
            ]
        ]
