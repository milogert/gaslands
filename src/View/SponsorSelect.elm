module View.SponsorSelect exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, placeholder, rel, src, type_, value, multiple, size)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Sponsors exposing (..)
import View.Sponsor
import View.Utils


view : Model -> Html Msg
view model =
    let
        body =
            case model.sponsor of
                Just s ->
                    View.Sponsor.render s

                Nothing ->
                    text "Select a sponsor."
    in
        View.Utils.row
            [ View.Utils.col "md-3"
                [ select
                    [ onInput SponsorUpdate
                    , class "form-control mb-3"
                    , size 8
                    ]
                  <|
                    (option [] [ text "No Sponsor" ])
                        :: (allSponsors
                                |> List.map .name
                                |> List.map toString
                                |> List.map (\t -> option [ value t ] [ text t ])
                           )
                ]
            , View.Utils.col "md-9" [ body ]
            ]
