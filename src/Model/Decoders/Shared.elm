module Model.Decoders.Shared exposing
    ( categoryDecoderHelper
    , requiredSponsorDecoderHelper
    , specialDecoder
    )

import Json.Decode exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (Sponsor)


specialDecoder : Decoder Special
specialDecoder =
    field "type" string
        |> andThen specialDecoderHelper


specialDecoderHelper : String -> Decoder Special
specialDecoderHelper str =
    case str of
        "Ammo" ->
            ammoDecoder

        "SpecialRule" ->
            specialRuleDecoder

        "NamedSpecialRule" ->
            namedSpecialRuleDecoder

        "Blast" ->
            blastDecoder

        "Fire" ->
            fireDecoder

        "Blitz" ->
            blitzDecoder

        "Electrical" ->
            electricalDecoder

        "HandlingMod" ->
            handlingModDecoder

        "HullMod" ->
            hullModDecoder

        "GearMod" ->
            gearModDecoder

        "CrewMod" ->
            crewModDecoder

        _ ->
            fail <| str ++ " is not a valid special type"


ammoDecoder : Decoder Special
ammoDecoder =
    map Ammo (field "clip" (list bool))


specialRuleDecoder : Decoder Special
specialRuleDecoder =
    map SpecialRule (field "text" string)


namedSpecialRuleDecoder : Decoder Special
namedSpecialRuleDecoder =
    map2 NamedSpecialRule (field "name" string) (field "text" string)


blastDecoder : Decoder Special
blastDecoder =
    succeed Blast


fireDecoder : Decoder Special
fireDecoder =
    succeed Fire


blitzDecoder : Decoder Special
blitzDecoder =
    succeed Blitz


electricalDecoder : Decoder Special
electricalDecoder =
    succeed Electrical


handlingModDecoder : Decoder Special
handlingModDecoder =
    map HandlingMod (field "modifier" int)


hullModDecoder : Decoder Special
hullModDecoder =
    map HullMod (field "modifier" int)


gearModDecoder : Decoder Special
gearModDecoder =
    map GearMod (field "modifier" int)


crewModDecoder : Decoder Special
crewModDecoder =
    map CrewMod (field "modifier" int)


requiredSponsorDecoderHelper : String -> Decoder (Maybe Sponsor)
requiredSponsorDecoderHelper str =
    let
        mSponsor =
            Model.Sponsors.stringToSponsor str
    in
    case mSponsor of
        Just sponsor ->
            succeed <| Just sponsor

        Nothing ->
            fail <| str ++ " is not a valid sponsor type"


categoryDecoderHelper : String -> Decoder Category
categoryDecoderHelper str =
    case str of
        "Basic" ->
            succeed Basic

        "Advanced" ->
            succeed Advanced

        _ ->
            fail <| str ++ " is not a valid category type"
