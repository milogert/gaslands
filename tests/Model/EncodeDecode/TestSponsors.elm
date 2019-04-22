module Model.EncodeDecode.TestSponsors exposing (suite)

import Expect exposing (Expectation)
import Json.Decode as JsonD
import Json.Encode as JsonE
import Model.Decoders.Sponsors exposing (..)
import Model.Encoders.Sponsors exposing (..)
import Model.Sponsors exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "sponsors: thing -> encode -> decode -> thing" <|
        []
            ++ teamPerks
            ++ perkClasses
            ++ vehiclePerks


teamPerks : List Test
teamPerks =
    []


perkClasses : List Test
perkClasses =
    [ Aggression
    , Badass
    , Daring
    , Military
    , Precision
    , Speed
    , Technology
    , PrisonCars
    ]
        |> List.map testPerkClass


testPerkClass : PerkClass -> Test
testPerkClass perkClass =
    test ("perkClass: " ++ fromPerkClass perkClass) <|
        \_ ->
            perkClass
                |> fromPerkClass
                |> JsonE.string
                |> JsonD.decodeValue (JsonD.string |> JsonD.andThen perkClassDecoderHelper)
                |> Expect.equal (Ok perkClass)


vehiclePerks : List Test
vehiclePerks =
    []
