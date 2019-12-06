module View.Utils exposing
    ( crewUsed
    , detailSection
    , expansionMarker
    , factBadge
    , factsHolder
    , icon
    , iconClass
    , iconb
    , plural
    , renderCountDown
    , renderDice
    , renderSpecial
    , tagGen
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
import Bootstrap.Utilities.Spacing as Spacing
import Bulma.Elements exposing (..)
import Bulma.Modifiers exposing (..)
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

        ( Blast, _, _ ) ->
            text <| fromSpecial special

        ( Fire, _, _ ) ->
            text <| fromSpecial special

        ( Explosive, _, _ ) ->
            text <| fromSpecial special

        ( Blitz, _, _ ) ->
            text <| fromSpecial special

        ( Electrical, _, _ ) ->
            text <| fromSpecial special

        ( Specialist, _, _ ) ->
            text <| fromSpecial special

        ( Entangle, _, _ ) ->
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


renderDice : Dice -> String
renderDice dice =
    String.fromInt dice.number ++ "d" ++ String.fromInt dice.die


crewUsed : Vehicle -> Int
crewUsed v =
    List.length <| List.filter (\x -> x.status == WeaponFired) v.weapons


factsHolder : List String -> Html Msg
factsHolder facts =
    div [ Spacing.mb2 ] <|
        List.map factBadge facts


factBadge : String -> Html Msg
factBadge fact =
    Badge.badgeSecondary [ class "mr-2" ] [ text fact ]


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


plural : Int -> String
plural i =
    case i of
        1 ->
            ""

        _ ->
            "s"


tagGen : String -> Maybe String -> Html Msg
tagGen title value =
    let
        titleTag =
            easyTag { tagModifiers | color = Dark } [] title
    in
    case value of
        Nothing ->
            multitag []
                [ titleTag ]

        Just v ->
            multitag []
                [ titleTag
                , easyTag { tagModifiers | color = Info } [] v
                ]


expansionMarker : Expansion -> Html Msg
expansionMarker expansion =
    expansion
        |> fromExpansion
        |> Just
        |> tagGen "expansion"
