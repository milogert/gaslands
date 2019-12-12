module View.EquipmentLayout exposing (render)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Solid as Icon
import Html
    exposing
        ( Html
        , a
        , div
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
                    controlButton
                        { buttonModifiers
                            | iconLeft = Just ( Standard, [], Icon.viewIcon Icon.times )
                        }
                        []
                        [ onClick <| removeMsg thing
                        , style "cursor" "pointer"
                        ]
                        []
    in
    div []
        [ title H6
            []
            [ text ""
            , text <| thing.name ++ " "
            , small []
                [ text <| Model.Shared.fromExpansion thing.expansion ]
            ]
        , div [] leftCol
        , div
            []
            rightCol
        ]
