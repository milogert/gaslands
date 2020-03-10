module View.EquipmentLayout exposing (render)

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Icon as Icon
import FontAwesome.Solid as Icon
import Html
    exposing
        ( Html
        , div
        , text
        )
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Model.Model exposing (..)
import Model.Shared exposing (..)


render :
    List (Html.Attribute Msg)
    -> { a | name : String, specials : List Special }
    -> Maybe ({ a | name : String, specials : List Special } -> Msg)
    -> List (Html Msg)
    -> List (Html Msg)
    -> Html Msg
render attrs thing mRemoveMsg factsHolderBody specialsBody =
    let
        deleteButton =
            case mRemoveMsg of
                Nothing ->
                    text ""

                Just removeMsg ->
                    controlButton
                        { buttonModifiers
                            | iconLeft = Just ( Standard, [], Icon.viewIcon Icon.times )
                            , size = Bulma.Modifiers.Small
                            , color = Danger
                        }
                        []
                        [ onClick <| removeMsg thing
                        , style "cursor" "pointer"
                        ]
                        []
    in
    div attrs
        [ level [ class "is-mobile" ]
            [ levelLeft []
                [ levelItem [] [ title H6 [] [ text thing.name ] ] ]
            , levelRight []
                [ levelItem [] [ deleteButton ] ]
            ]
        , div [ class "facts-holder" ] factsHolderBody
        , div [ class "special-holder" ] specialsBody
        ]
