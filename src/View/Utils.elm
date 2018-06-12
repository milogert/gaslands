module View.Utils exposing (card, crewUsed, detailSection, renderCountDown, renderDice, renderSpecial, row, rowPlus, col, colPlus)

import Html exposing (Html, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onInput)
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


card : List ( String, Bool ) -> Html Msg -> Html Msg -> Html Msg
card cl body footer =
    div [ class "card", classList cl ]
        [ div [ class "card-body" ] [ body ]
        , div [ class "card-footer" ] [ footer ]
        ]


detailSection : CurrentView -> Bool -> List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection currentView isPreview headerContents bodyContents =
    div [ classList [ ( "d-none", currentView == Overview || isPreview ) ] ]
        [ hr [] [], h5 [] headerContents, div [] bodyContents ]


renderSpecial : Bool -> Maybe (Int -> String -> Msg) -> Int -> Special -> Html Msg
renderSpecial isPreview ammoMsg ammoUsed s =
    case s of
        Ammo i ->
            case isPreview of
                True ->
                    div [] [ text <| "Ammo: " ++ (toString i) ]

                False ->
                    div [ class "form-row" ]
                        [ label [ class "col-form-label" ] [ text "Ammo: " ]
                        , renderCountDown ammoMsg i ammoUsed
                        ]

        HighlyExplosive ->
            text "Highly Explosive"

        TreacherousSurface ->
            text "The dropped template counts as a treacherous surface."

        SpecialRule s ->
            text <| "Special: " ++ s

        HandlingMod i ->
            text <| "Handling modification: " ++ (toString i)

        HullMod i ->
            text <| "Hull modification: " ++ (toString i)

        GearMod i ->
            text <| "Gear modification: " ++ (toString i)

        CrewMod i ->
            text <| "Crew modification: " ++ (toString i)

        _ ->
            text <| toString s


renderCountDown : Maybe (Int -> String -> Msg) -> Int -> Int -> Html Msg
renderCountDown msg start current =
    let
        baseAttr =
            [ class "form-control form-control-sm"
            , type_ "number"
            , Html.Attributes.max <| toString start
            , Html.Attributes.min "0"
            , value <| toString <| start - current
            ]

        attr =
            case msg of
                Nothing ->
                    baseAttr

                Just m ->
                    (onInput <| m start) :: baseAttr
    in
        col "" [ input attr [] ]


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
