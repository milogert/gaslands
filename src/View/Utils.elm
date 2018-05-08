module View.Utils exposing (card, crewUsed, detailSection, renderChecksRange, renderChecksRangePreChecked, renderDice, renderSpecial)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


card : Html Msg -> Html Msg -> Html Msg
card header body =
    div [ class "card p-1" ]
        [ div [ class "card-body" ]
            [ header, body ]
        ]


detailSection : CurrentView -> Bool -> List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection currentView isPreview headerContents bodyContents =
    div [ classList [ ( "d-none", currentView == Overview || isPreview ) ] ]
        [ hr [] [], h5 [] headerContents, div [] bodyContents ]


renderSpecial : Special -> Html Msg
renderSpecial s =
    case s of
        Ammo i ->
            div [] (text "Ammo: " :: renderChecksRange i)

        _ ->
            text <| toString s


renderChecksRange : Int -> List (Html Msg)
renderChecksRange i =
    renderChecksRangePreChecked i 0


renderChecksRangePreChecked : Int -> Int -> List (Html Msg)
renderChecksRangePreChecked ti ci =
    let
        ucBox =
            input [ type_ "checkbox", class "ml-1" ] []

        cBox =
            input [ type_ "checkbox", class "ml-1", checked True ] []
    in
    List.map
        (\ri ->
            if ri <= ci then
                cBox
            else
                ucBox
        )
        (List.range 1 ti)


renderDice : Dice -> String
renderDice { number, die } =
    case ( number, die ) of
        ( 0, 0 ) ->
            "None"

        ( _, _ ) ->
            toString number ++ "d" ++ toString die


crewUsed : Vehicle -> Int
crewUsed v =
    List.length <| List.filter (\x -> List.member CrewFired x.specials) v.weapons
