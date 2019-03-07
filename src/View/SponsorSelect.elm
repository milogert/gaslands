module View.SponsorSelect exposing (view)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html
    exposing
        ( Html
        , option
        , select
        , text
        )
import Html.Attributes
    exposing
        ( class
        , selected
        , size
        , value
        )
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

        currentSponsorName =
            case model.sponsor of
                Nothing ->
                    ""

                Just s ->
                    s.name

        optionFunc t =
            option
                [ value t
                , selected <| currentSponsorName == t
                ]
                [ text t ]
    in
    Grid.row []
        [ Grid.col [ Col.md3 ]
            [ select
                [ onInput SponsorUpdate
                , class "form-control mb-3"
                , size 8
                ]
              <|
                option [] [ text "No Sponsor" ]
                    :: (allSponsors
                            |> List.map .name
                            |> List.map optionFunc
                       )
            ]
        , Grid.col [ Col.md9 ] [ body ]
        ]
