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
    , renderSpecialRow
    , specialToHeaderBody
    , tagGen
    , tagList
    , vehicleSponsorFilter
    , weaponSponsorFilter
    )

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Layout exposing (..)
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
import Html.Attributes exposing (checked, class, classList, hidden, id)
import Html.Events exposing (onCheck, onInput)
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


detailSection : String -> List (Html Msg) -> List (Html Msg) -> Html Msg
detailSection titleString detailButtons bodyContents =
    div []
        [ hr [] []
        , level []
            [ levelLeft []
                [ levelItem []
                    [ title H5 [] [ text titleString ] ]
                ]
            , levelRight [ classList [ ( "is-hidden", List.isEmpty detailButtons ) ] ]
                [ levelItem [] detailButtons ]
            ]
        , div [] bodyContents
        ]


renderSpecialRow : Maybe ( Html Msg, Html Msg ) -> Html Msg
renderSpecialRow mHeaderBody =
    case mHeaderBody of
        Nothing ->
            div [] []

        Just ( label, body ) ->
            horizontalFields
                []
                [ fieldLabel Standard [] [ controlLabel [] [ label ] ]
                , fieldBody [] [ field [] [ body ] ]
                ]


specialToHeaderBody : Bool -> Bool -> Maybe (event -> Msg) -> Maybe (Int -> Bool -> event) -> Special -> Maybe ( Html Msg, Html Msg )
specialToHeaderBody isPreview isPrinting mMsg mEvent special =
    case ( special, mMsg, mEvent ) of
        ( Ammo ammo, Just msg, Just event ) ->
            case ( isPreview, isPrinting ) of
                ( True, _ ) ->
                    Just ( text "Ammo", text (String.fromInt <| List.length ammo) )

                ( _, True ) ->
                    Just
                        ( text "Ammo"
                        , div [] <|
                            List.repeat
                                (List.length ammo)
                                (div [ class "hazard-check" ] [])
                        )

                ( False, False ) ->
                    Just
                        ( text "Ammo"
                        , renderCountDown msg event ammo
                        )

        ( Ammo _, Nothing, _ ) ->
            Nothing

        ( Ammo _, _, Nothing ) ->
            Nothing

        ( HighlyExplosive, _, _ ) ->
            Just
                ( text "Highly Explosive"
                , text ""
                )

        ( TreacherousSurface, _, _ ) ->
            Just
                ( text "Treacherous Surface"
                , text "The dropped template counts as a treacherous surface."
                )

        ( SpecialRule rule, _, _ ) ->
            Just
                ( text "Note", text rule )

        ( NamedSpecialRule name rule, _, _ ) ->
            Just ( text name, text rule )

        ( HandlingMod i, _, _ ) ->
            Just
                ( text "Handling mod"
                , text <| needPlus i ++ " modification to the vehicle's base Handling value."
                )

        ( HullMod i, _, _ ) ->
            Just
                ( text "Hull mod"
                , text <| needPlus i ++ " modification to the vehicle's base Hull value."
                )

        ( GearMod i, _, _ ) ->
            Just
                ( text "Gear mod"
                , text <| needPlus i ++ " modification to the vehicle's maximum Gear."
                )

        ( CrewMod i, _, _ ) ->
            Just
                ( text "Crew mod"
                , text <| needPlus i ++ " modification to the vehicle's base Crew value."
                )

        ( _, _, _ ) ->
            Just ( text <| fromSpecial special, text "" )


needPlus : Int -> String
needPlus i =
    case compare i 0 of
        LT ->
            String.fromInt i

        _ ->
            "+" ++ String.fromInt i


renderCountDown : (event -> Msg) -> (Int -> Bool -> event) -> List Bool -> Html Msg
renderCountDown msg event checks =
    let
        checkboxFunc index check =
            controlCheckBox
                False
                []
                []
                [ id <| String.fromInt index
                , checked check
                , onCheck (msg << event index)
                ]
                []
    in
    multilineFields [] <|
        List.indexedMap checkboxFunc checks


renderDice : Dice -> String
renderDice dice =
    String.fromInt dice.number ++ "d" ++ String.fromInt dice.die


crewUsed : Vehicle -> Int
crewUsed v =
    List.length <| List.filter (\x -> x.status == WeaponFired) v.weapons


factsHolder : List String -> Html Msg
factsHolder facts =
    div [] <|
        List.map factBadge facts


factBadge : String -> Html Msg
factBadge fact =
    tag tagModifiers [] [ text fact ]


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


tagList : List ( ( String, Color ), ( Maybe String, Color ) ) -> Html Msg
tagList tagConfig =
    tagConfig
        |> List.map (\config -> tagGen (Tuple.first config) (Tuple.second config))
        |> List.map (\t -> control controlModifiers [] [ t ])
        |> multilineFields []


tagGen : ( String, Color ) -> ( Maybe String, Color ) -> Html Msg
tagGen ( title, titleColor ) ( mValue, valueColor ) =
    let
        titleTag =
            easyTag { tagModifiers | color = titleColor } [] title
    in
    case mValue of
        Nothing ->
            multitag [] [ titleTag ]

        Just value ->
            multitag []
                [ titleTag
                , easyTag { tagModifiers | color = valueColor } [] value
                ]


expansionMarker : Expansion -> Html Msg
expansionMarker expansion =
    ( Just <| fromExpansion expansion, Info )
        |> tagGen ( "expansion", Bulma.Modifiers.Light )
