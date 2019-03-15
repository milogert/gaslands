module Model.Decoders.Shared exposing
    ( expansionDecoder
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

        "TreacherousSurface" ->
            succeed TreacherousSurface

        "Blast" ->
            blastDecoder

        "Fire" ->
            fireDecoder

        "Explosive" ->
            explosiveDecoder

        "Blitz" ->
            blitzDecoder

        "HighlyExplosive" ->
            highlyExplosiveDecoder

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

        "Specialist" ->
            specialistDecoder

        "Entangle" ->
            entangleDecoder

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


explosiveDecoder : Decoder Special
explosiveDecoder =
    succeed Explosive


blitzDecoder : Decoder Special
blitzDecoder =
    succeed Blitz


highlyExplosiveDecoder : Decoder Special
highlyExplosiveDecoder =
    succeed HighlyExplosive


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


specialistDecoder : Decoder Special
specialistDecoder =
    succeed Specialist


entangleDecoder : Decoder Special
entangleDecoder =
    succeed Entangle


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


expansionDecoder : Decoder Expansion
expansionDecoder =
    field "type" string
        |> andThen expansionDecoderHelper


expansionDecoderHelper : String -> Decoder Expansion
expansionDecoderHelper type_ =
    case type_ of
        "Base Game" ->
            succeed BaseGame

        "Time Extended" ->
            map TX (field "number" int)

        _ ->
            fail <| type_ ++ " is not a valid expansion."
