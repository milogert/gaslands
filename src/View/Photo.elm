module View.Photo exposing (view, renderPhoto)


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
                    (True, False)

                Just p ->
                    (False, True)

        videoDisplay =
            video
                [ autoplay True
                , onClick <| TakePhoto v
                , style [ ( "max-width", "100%" ) ]
                , classList [ ( "d-none", not displayStream) ]
                ]
                []
    in
    View.Utils.row
        [ div
            [ class "col-12 offset-md-3 col-md-6"
            ]
            [ div
                [ class "card" ]
                [ videoDisplay
                , renderPhoto v.photo displayPhoto
                , div [ class "card-body" ]
                    [ discardButton ]
                ]
            ]
        ]


renderPhoto : Maybe String -> Bool -> Html Msg
renderPhoto murl shouldDisplay =
    img
        [ src <| Maybe.withDefault "" murl
        , class "card-img-top"
        , classList [ ( "d-none", not shouldDisplay) ]
        ]
        []

