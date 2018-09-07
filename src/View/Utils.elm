module View.Utils exposing (icon, iconClass, card, crewUsed, detailSection, renderCountDown, renderDice, renderSpecial, row, rowPlus, col, colPlus, factsHolder, factBadge)

import Html exposing (Html, node, button, div, h1, h2, h3, h4, h5, h6, hr, img, input, label, li, node, option, p, select, small, span, text, textarea, ul, b)
import Html.Attributes exposing (checked, class, classList, disabled, for, href, id, max, min, placeholder, rel, src, type_, value)
import Html.Events exposing (onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


icon : String -> Html Msg
icon s =
    iconClass s []


iconClass : String -> List String -> Html Msg
iconClass s cl =
    node
        "i"
        [ class <| "m-1 fas fa-" ++ s
        , classList <| List.map (\c -> ( c, True )) cl
        ]
        []


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


card : List ( String, Bool ) -> Html Msg -> Html Msg -> Bool -> Html Msg
card cl body footer hideFooter =
    div [ class "card", classList cl ]
        [ div [ class "card-body" ] [ body ]
        , div
            [ class "card-footer", classList [ ( "d-none", hideFooter ) ] ]
            [ footer ]
        ]


detailSection : CurrentView -> List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection currentView headerContents bodyContents =
    div [ classList [ ( "d-none", currentView == Overview ) ] ]
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
            text <| s

        NamedSpecialRule name rule ->
            span [] [ b [] [ text <| name ++ ": " ], text rule ]

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


renderDice : Maybe Dice -> String
renderDice maybeDice =
    case maybeDice of
        Nothing ->
            ""

        Just dice ->
            toString dice.number ++ "d" ++ toString dice.die


crewUsed : Vehicle -> Int
crewUsed v =
    List.length <| List.filter (\x -> x.status == WeaponFired) v.weapons


factsHolder : List (Html Msg) -> Html Msg
factsHolder facts =
    div [ class "text-center mb-2" ] facts


factBadge : String -> Html Msg
factBadge factString =
    span [ class "badge badge-secondary mr-2" ] [ text factString ]
