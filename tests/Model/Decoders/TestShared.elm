module Model.Decoders.TestShared exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (..)
import Json.Encode exposing (..)
import Model.Decoders.Shared exposing (..)
import Model.Shared exposing (..)
import Model.Sponsors exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "shared decoders tests" <|
        specialDecodeTestGenerator
            ++ expansionDecodeTestGenerator
            ++ sponsorDecodeTestGenerator


specialDecodeTestGenerator : List Test
specialDecodeTestGenerator =
    [ ( "{\"type\": \"Ammo\", \"clip\": [true, false]}"
      , Ok <| Ammo [ True, False ]
      )
    , ( "{\"type\": \"SpecialRule\", \"text\": \"the special rule\"}"
      , Ok <| SpecialRule "the special rule"
      )
    , ( "{\"type\": \"NamedSpecialRule\", \"name\": \"named\", \"text\": \"the named special rule\"}"
      , Ok <| NamedSpecialRule "named" "the named special rule"
      )
    , ( "{\"type\": \"TreacherousSurface\"}"
      , Ok TreacherousSurface
      )
    , ( "{\"type\": \"Blast\"}"
      , Ok Blast
      )
    , ( "{\"type\": \"Fire\"}"
      , Ok Fire
      )
    , ( "{\"type\": \"Explosive\"}"
      , Ok Explosive
      )
    , ( "{\"type\": \"Blitz\"}"
      , Ok Blitz
      )
    , ( "{\"type\": \"HighlyExplosive\"}"
      , Ok HighlyExplosive
      )
    , ( "{\"type\": \"Electrical\"}"
      , Ok Electrical
      )
    , ( "{\"type\": \"HandlingMod\", \"modifier\": 7}"
      , Ok <| HandlingMod 7
      )
    , ( "{\"type\": \"HullMod\", \"modifier\": 8}"
      , Ok <| HullMod 8
      )
    , ( "{\"type\": \"GearMod\", \"modifier\": 9}"
      , Ok <| GearMod 9
      )
    , ( "{\"type\": \"CrewMod\", \"modifier\": 10}"
      , Ok <| CrewMod 10
      )
    , ( "{\"type\": \"garbo\"}"
      , Err
            (Failure
                "garbo is not a valid special type"
                (Json.Encode.object [ ( "type", Json.Encode.string "garbo" ) ])
            )
      )
    ]
        |> List.map
            (\( json, special ) ->
                test ("test special decoding: " ++ json) <|
                    \_ ->
                        json
                            |> decodeString specialDecoder
                            |> Expect.equal special
            )


expansionDecodeTestGenerator : List Test
expansionDecodeTestGenerator =
    [ ( "{\"type\": \"Base Game\"}"
      , Ok <| BaseGame
      )
    , ( "{\"type\": \"Time Extended\", \"number\": 2}"
      , Ok <| TX 2
      )
    , ( "{\"type\": \"garbo\"}"
      , Err
            (Failure
                "garbo is not a valid expansion."
                (Json.Encode.object [ ( "type", Json.Encode.string "garbo" ) ])
            )
      )
    ]
        |> List.map
            (\( json, expansion ) ->
                test ("test expansion decoding: " ++ json) <|
                    \_ ->
                        json
                            |> decodeString expansionDecoder
                            |> Expect.equal expansion
            )


sponsorDecodeTestGenerator : List Test
sponsorDecodeTestGenerator =
    [ ( "\"Rutherford\""
      , allSponsors
            |> List.head
            |> Ok
      )
    , ( "\"garbo\""
      , Err
            (Failure
                "garbo is not a valid sponsor type"
                (Json.Encode.string "garbo")
            )
      )
    ]
        |> List.map
            (\( json, expansion ) ->
                test ("test expansion decoding: " ++ json) <|
                    \_ ->
                        json
                            |> decodeString (Json.Decode.string |> Json.Decode.andThen requiredSponsorDecoderHelper)
                            |> Expect.equal expansion
            )
