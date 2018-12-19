module View.SponsorSelect exposing (view)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, disabled, for, href, id, max, min, multiple, placeholder, rel, selected, size, src, type_, value)
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
                    View.Sponsor.render <| Model.Sponsors.typeToSponsor s

                Nothing ->
                    text "Select a sponsor."

        currentSponsorName =
            case model.sponsor of
                Nothing ->
                    ""

                Just s ->
                    fromSponsorType s

        optionFunc t =
            option
                [ value t
                , selected <| currentSponsorName == t
                ]
                [ text t ]
    in
    View.Utils.row
        [ View.Utils.col "md-3"
            [ select
                [ onInput SponsorUpdate
                , class "form-control mb-3"
                , size 8
                ]
              <|
                option [] [ text "No Sponsor" ]
                    :: (allSponsors
                            |> List.map .name
                            |> List.map fromSponsorType
                            |> List.map optionFunc
                       )
            ]
        , View.Utils.col "md-9" [ body ]
        ]
