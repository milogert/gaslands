module Model.Encoders.Shared exposing (specialEncoder)

import Json.Encode exposing (..)
import Model.Shared exposing (..)


specialEncoder : Special -> Value
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


ammoEncoder : Int -> Value
ammoEncoder i =
    object [ ( "type", string "Ammo" ), ( "count", int i ) ]


specialRuleEncoder : String -> Value
specialRuleEncoder t =
    object [ ( "type", string "SpecialRule" ), ( "text", string t ) ]


namedSpecialRuleEncoder : String -> String -> Value
namedSpecialRuleEncoder t1 t2 =
    object
        [ ( "type", string "NamedSpecialRule" )
        , ( "name", string t1 )
        , ( "text", string t2 )
        ]


genericEncoder : Special -> Value
genericEncoder s =
    object [ ( "type", string <| toString s ) ]


modEncoder : Special -> Int -> Value
modEncoder s i =
    object [ ( "type", string <| modEncoderHelper s ), ( "modifier", int i ) ]


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
