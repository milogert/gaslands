module View.Photo exposing (renderPhoto, view)

import Html exposing (Html, a, button, div, img, text, video)
import Html.Attributes exposing (autoplay, class, classList, href, src, style)
import Html.Events exposing (onClick)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)


view : Model -> Vehicle -> Html Msg
view model v =
    let
        discardButton =
            a
                [ href "#"
                , class "text-danger"
                , onClick <| VehicleMsg <| DiscardPhoto v.key
                ]
                [ text "(Re)Take Photo" ]

        ( displayStream, displayPhoto ) =
            case v.photo of
                Nothing ->
                    ( True, False )

                Just p ->
                    ( False, True )

        videoDisplay =
            video
                [ autoplay True
                , onClick <| VehicleMsg <| TakePhoto v.key
                , style "max-width" "100%"
                , classList [ ( "d-none", not displayStream ) ]
                ]
                []
    in
    div
        [ class "card" ]
        [ videoDisplay
        , renderPhoto v.photo displayPhoto
        , div [ class "card-body text-center" ]
            [ discardButton ]
        ]


renderPhoto : Maybe String -> Bool -> Html Msg
renderPhoto murl shouldDisplay =
    img
        [ src <| Maybe.withDefault "" murl
        , class "card-img-top"
        , classList [ ( "d-none", not shouldDisplay ) ]
        ]
        []
