module View.SponsorSelect exposing (view)

import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import Html
    exposing
        ( Html
        , div
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
import Model.Shared exposing (expansionFilter)
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
    div []
        [ horizontalFields []
            [ fieldLabel Standard
                []
                [ controlLabel [] [ text "Sponsor List" ] ]
            , fieldBody []
                [ controlSelect controlSelectModifiers
                    []
                    [ onInput SponsorUpdate
                    , class "form-control mb-3"
                    ]
                  <|
                    option [] [ text "No Sponsor" ]
                        :: (allSponsors
                                |> List.filter (expansionFilter model.settings.expansions.enabled)
                                |> List.map .name
                                |> List.map optionFunc
                           )
                ]
            ]
        , box [] [ body ]
        ]
