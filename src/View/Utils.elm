module View.Utils exposing
    ( crewUsed
    , detailSection
    , factBadge
    , factsHolder
    , icon
    , iconClass
    , iconb
    , renderCountDown
    , renderDice
    , renderSpecial
    , vehicleSponsorFilter
    , weaponSponsorFilter
    )

import Bootstrap.Badge as Badge
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Html
    exposing
        ( Html
        , b
        , div
        , h5
        , hr
        , node
        , span
        , text
        )
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


icon : String -> Html Msg
icon s =
    iconClass "fas" s []


iconb : String -> Html Msg
iconb s =
    iconClass "fab" s []


iconClass : String -> String -> List String -> Html Msg
iconClass styleOrBrand s cl =
    node
        "i"
        [ class <| "m-1 " ++ styleOrBrand ++ " fa-" ++ s
        , classList <| List.map (\c -> ( c, True )) cl
        ]
        []


mapClassList : List String -> List ( String, Bool )
mapClassList classes =
    List.map (\x -> ( x, True )) classes


detailSection : CurrentView -> List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection currentView headerContents bodyContents =
    div [ classList [ ( "d-none", currentView == ViewDashboard ) ] ]
        [ hr [] [], h5 [] headerContents, div [] bodyContents ]


renderSpecial : Bool -> Maybe (Int -> String -> Msg) -> Int -> Special -> Html Msg
renderSpecial isPreview ammoMsg ammoUsed s =
    case s of
        Ammo i ->
            case isPreview of
                True ->
                    div [] [ text <| "Ammo: " ++ String.fromInt i ]

                False ->
                    Form.row []
                        [ Form.colLabel [] [ text "Ammo: " ]
                        , renderCountDown ammoMsg i ammoUsed
                        ]

        HighlyExplosive ->
            text "Highly Explosive"

        TreacherousSurface ->
            text "The dropped template counts as a treacherous surface."

        SpecialRule rule ->
            text rule

        NamedSpecialRule name rule ->
            span [] [ b [] [ text <| name ++ ": " ], text rule ]

        HandlingMod i ->
            text <| "Handling modification: " ++ String.fromInt i

        HullMod i ->
            text <| "Hull modification: " ++ String.fromInt i

        GearMod i ->
            text <| "Gear modification: " ++ String.fromInt i

        CrewMod i ->
            text <| "Crew modification: " ++ String.fromInt i

        _ ->
            text <| fromSpecial s


renderCountDown : Maybe (Int -> String -> Msg) -> Int -> Int -> Form.Col Msg
renderCountDown msg start current =
    let
        baseAttr =
            [ Input.small
            , Input.value <| String.fromInt <| start - current
            , Input.attrs
                [ Html.Attributes.max <| String.fromInt start
                , Html.Attributes.min "0"
                ]
            ]

        attr =
            case msg of
                Nothing ->
                    baseAttr

                Just m ->
                    (Input.onInput <| m start) :: baseAttr
    in
    Form.col [] [ Input.number attr ]


renderDice : Maybe Dice -> String
renderDice maybeDice =
    case maybeDice of
        Nothing ->
            ""

        Just dice ->
            String.fromInt dice.number ++ "d" ++ String.fromInt dice.die


crewUsed : Vehicle -> Int
crewUsed v =
    List.length <| List.filter (\x -> x.status == WeaponFired) v.weapons


factsHolder : List (Html Msg) -> Html Msg
factsHolder facts =
    div [ class "text-center mb-2" ] facts


factBadge : String -> Html Msg
factBadge factString =
    Badge.badgeSecondary [ class "mr-2" ] [ text factString ]


vehicleSponsorFilter : Model -> Vehicle -> Bool
vehicleSponsorFilter model v =
    sponsorFilter_ model v.requiredSponsor


weaponSponsorFilter : Model -> Weapon -> Bool
weaponSponsorFilter model weapon =
    sponsorFilter_ model weapon.requiredSponsor


sponsorFilter_ : Model -> Maybe SponsorType -> Bool
sponsorFilter_ model mst =
    case ( model.sponsor, mst ) of
        ( _, Nothing ) ->
            True

        ( Nothing, _ ) ->
            Nothing == mst

        ( Just sponsor, Just vehicleSponsor ) ->
            sponsor == vehicleSponsor
