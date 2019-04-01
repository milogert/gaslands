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
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
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
import Html.Attributes exposing (class, classList, hidden)
import Html.Events exposing (onInput)
import Model.Model exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Model exposing (..)


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


detailSection : List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection headerContents bodyContents =
    div []
        [ hr [] [], h5 [] headerContents, div [] bodyContents ]


renderSpecial : Bool -> Bool -> Maybe (event -> Msg) -> Maybe (Int -> Bool -> event) -> Special -> Html Msg
renderSpecial isPreview isPrinting mMsg mEvent special =
    case ( special, mMsg, mEvent ) of
        ( Ammo ammo, Just msg, Just event ) ->
            case ( isPreview, isPrinting ) of
                ( True, _ ) ->
                    div [] [ text <| "Ammo: " ++ (String.fromInt <| List.length ammo) ]

                ( _, True ) ->
                    div [] (text "Ammo:" :: List.repeat (List.length ammo) (div [ class "hazard-check" ] []))

                ( False, False ) ->
                    Form.row [ Row.middleXs, Row.attrs [ class "mb-0" ] ]
                        [ Form.colLabel [ Col.xsAuto ] [ text "Ammo: " ]
                        , renderCountDown msg event ammo
                        ]

        ( Ammo _, Nothing, _ ) ->
            text ""

        ( Ammo _, _, Nothing ) ->
            text ""

        ( HighlyExplosive, _, _ ) ->
            text "Highly Explosive"

        ( TreacherousSurface, _, _ ) ->
            text "The dropped template counts as a treacherous surface."

        ( SpecialRule rule, _, _ ) ->
            text rule

        ( NamedSpecialRule name rule, _, _ ) ->
            span [] [ b [] [ text <| name ++ ": " ], text rule ]

        ( HandlingMod i, _, _ ) ->
            text <| "Handling modification: " ++ String.fromInt i

        ( HullMod i, _, _ ) ->
            text <| "Hull modification: " ++ String.fromInt i

        ( GearMod i, _, _ ) ->
            text <| "Gear modification: " ++ String.fromInt i

        ( CrewMod i, _, _ ) ->
            text <| "Crew modification: " ++ String.fromInt i

        ( _, _, _ ) ->
            text <| fromSpecial special


renderCountDown : (event -> Msg) -> (Int -> Bool -> event) -> List Bool -> Form.Col Msg
renderCountDown msg event checks =
    let
        checkboxFunc index check =
            Checkbox.checkbox
                [ Checkbox.id <| String.fromInt index
                , Checkbox.inline
                , Checkbox.checked check
                , Checkbox.onCheck (msg << event index)
                ]
                ""
    in
    Form.col []
        [ Fieldset.config
            |> Fieldset.children
                (List.indexedMap checkboxFunc checks)
            |> Fieldset.view
        ]


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


sponsorFilter_ : Model -> Maybe Sponsor -> Bool
sponsorFilter_ model mst =
    case ( model.sponsor, mst ) of
        ( _, Nothing ) ->
            True

        ( Nothing, _ ) ->
            Nothing == mst

        ( Just sponsor, Just vehicleSponsor ) ->
            sponsor == vehicleSponsor
