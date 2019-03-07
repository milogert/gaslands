module Model.Decoders.TestShared exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (..)
import Model.Decoders.Shared exposing (..)
import Model.Shared exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "shared decoders tests"
        decodeTestGenerator


decodeTestGenerator : List Test
decodeTestGenerator =
    [ ( "{\"type\": \"Ammo\", \"clip\": [true, false]}"
      , Ok <| Ammo [ True, False ]
      )
    , ( "{\"type\": \"SpecialRule\", \"text\": \"the special rule\"}"
      , Ok <| SpecialRule "the special rule"
      )
    , ( "{\"type\": \"NamedSpecialRule\", \"name\": \"named\", \"text\": \"the named special rule\"}"
      , Ok <| NamedSpecialRule "named" "the named special rule"
      )
    , ( "{\"type\": \"TrecherousSurface\"}"
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

    {- , ( "{\"type\": \"garbo\"}"
       , Error "garbo is not a valid special type"
       )
    -}
    ]
        |> List.map
            (\( json, special ) ->
                test ("test special decoding: " ++ json) <|
                    \_ ->
                        json
                            |> decodeString specialDecoder
                            |> Expect.equal special
            )
