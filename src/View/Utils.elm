module View.Utils exposing (card, crewUsed, detailSection, renderChecksRange, renderChecksRangePreChecked, renderDice, renderSpecial, row, rowPlus, col, colPlus)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


row : List (Html Msg) -> Html Msg
row body =
    rowPlus [] body


rowPlus : List String -> List (Html Msg) -> Html Msg
rowPlus classes body =
    div [ class "row", classList <| mapClassList classes ] body


col : String -> List (Html Msg) -> Html Msg
col colMod body =
    case colMod of
        "" ->
            colPlus [] [] body

        _ ->
            colPlus [ colMod ] [] body


colPlus : List String -> List String -> List (Html Msg) -> Html Msg
colPlus colMods classes body =
    case colMods of
        [] ->
            div [ class "col", classList <| mapClassList classes ] body

        _ ->
            div
                [ classList <| (List.map (\x -> ( "col-" ++ x, True )) colMods) ++ (mapClassList classes) ]
                body


mapClassList : List String -> List ( String, Bool )
mapClassList classes =
    List.map (\x -> ( x, True )) classes


card : List (String, Bool) -> Html Msg -> Html Msg -> Html Msg -> Html Msg
card cl header body footer =
    div [ class "card", classList cl ]
        [ div [ class "card-header" ] [ header]
        , div [ class "card-body" ] [ body ]
        , div [ class "card-footer" ] [ footer ]
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

        CrewFired ->
            text "360 degree firing"

        HighlyExplosive ->
            text "Highly Explosive"

        TreacherousSurface ->
            text "The dropped template counts as a treacherous surface."

        SpecialRule s ->
            text <| "Special: " ++ s

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
    List.length <| List.filter (\x -> x.status == WeaponFired) v.weapons

