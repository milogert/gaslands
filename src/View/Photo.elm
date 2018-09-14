module View.Photo exposing (view)


import Html exposing (Html, text, div, button, video, img)
import Html.Attributes exposing (class, classList, style, autoplay, src)
import Html.Events exposing (onClick)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import View.Utils


view : Model -> Vehicle -> Html Msg
view model v =
    let
        discardButton =
            button
                [ class "btn btn-danger btn-block"
                , onClick <| DiscardPhoto v ]
                [ text "Discard" ]

        (displayStream, displayPhoto) =
            case v.photo of
                Nothing ->
                    Debug.log "stream, photo" (True, False)

                Just p ->
                    Debug.log "stream, photo" (False, True)

        videoDisplay =
            video
                [ autoplay True
                , onClick <| TakePhoto v
                , style [ ( "max-width", "100%" ) ]
                , classList [ ( "d-none", not displayStream) ]
                ]
                []

        imageDisplay url =
            img
                [ src url
                , class "card-img-top"
                , classList [ ( "d-none", not displayPhoto) ]
                ]
                []

    in
    View.Utils.row
        [ div
            [ class "col-3"
            ]
            [ div
                [ class "card" ]
                [ videoDisplay
                , imageDisplay <| Maybe.withDefault "" v.photo
                , div [ class "card-body" ]
                    [ discardButton ]
                ]
            ]
        ]
