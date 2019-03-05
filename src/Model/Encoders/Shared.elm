module Model.Encoders.Shared exposing
    ( expansionEncoder
    , requiredSponsorEncoder
    , specialEncoder
    )

import Json.Encode exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (SponsorType, fromSponsorType)


specialEncoder : Special -> List ( String, Value )
specialEncoder s =
    case s of
        Ammo ammo ->
            ammoEncoder ammo

        SpecialRule t ->
            specialRuleEncoder t

        NamedSpecialRule t1 t2 ->
            namedSpecialRuleEncoder t1 t2

        HandlingMod i ->
            modEncoder s i

        HullMod i ->
            modEncoder s i

        GearMod i ->
            modEncoder s i

        CrewMod i ->
            modEncoder s i

        _ ->
            genericEncoder s


ammoEncoder : List Bool -> List ( String, Value )
ammoEncoder clip =
    [ ( "type", string "Ammo" ), ( "clip", list bool clip ) ]


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


expansionEncoder : Expansion -> List ( String, Value )
expansionEncoder expansion =
    case expansion of
        BaseGame ->
            [ ( "type", string "Base Game" ) ]

        TX i ->
            [ ( "type", string "Time Extended" )
            , ( "number", int i )
            ]
