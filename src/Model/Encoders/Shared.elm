module Model.Encoders.Shared exposing (requiredSponsorEncoder, specialEncoder)

import Json.Encode exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (SponsorType, fromSponsorType)


specialEncoder : Special -> List ( String, Value )
specialEncoder s =
    case s of
        Ammo i ->
            ammoEncoder i

        SpecialRule t ->
            specialRuleEncoder t

        NamedSpecialRule t1 t2 ->
            namedSpecialRuleEncoder t1 t2

        TreacherousSurface ->
            genericEncoder s

        Blast ->
            genericEncoder s

        Fire ->
            genericEncoder s

        Explosive ->
            genericEncoder s

        Blitz ->
            genericEncoder s

        HighlyExplosive ->
            genericEncoder s

        Electrical ->
            genericEncoder s

        HandlingMod i ->
            modEncoder s i

        HullMod i ->
            modEncoder s i

        GearMod i ->
            modEncoder s i

        CrewMod i ->
            modEncoder s i


ammoEncoder : Int -> List ( String, Value )
ammoEncoder i =
    [ ( "type", string "Ammo" ), ( "count", int i ) ]


specialRuleEncoder : String -> List ( String, Value )
specialRuleEncoder t =
    [ ( "type", string "SpecialRule" ), ( "text", string t ) ]


namedSpecialRuleEncoder : String -> String -> List ( String, Value )
namedSpecialRuleEncoder name text =
    [ ( "type", string "NamedSpecialRule" )
    , ( "name", string name )
    , ( "text", string text )
    ]


genericEncoder : Special -> List ( String, Value )
genericEncoder s =
    [ ( "type", string <| fromSpecial s ) ]


modEncoder : Special -> Int -> List ( String, Value )
modEncoder s i =
    [ ( "type", string <| modEncoderHelper s ), ( "modifier", int i ) ]


modEncoderHelper : Special -> String
modEncoderHelper s =
    case s of
        HandlingMod _ ->
            "HandlingMod"

        HullMod _ ->
            "HullMod"

        GearMod _ ->
            "GearMod"

        CrewMod _ ->
            "CrewMod"

        _ ->
            ""


requiredSponsorEncoder : Maybe SponsorType -> Value
requiredSponsorEncoder mst =
    case mst of
        Nothing ->
            null

        Just st ->
            string <| fromSponsorType st
