module Model.TestSponsors exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeValue, errorToString)
import Json.Encode
import Model.Model exposing (..)
import Model.Sponsors exposing (..)
import Model.Vehicle.Model exposing (defaultVehicle)
import Test exposing (..)


suite : Test
suite =
    describe "Model tests" <|
        [ perkClassTests
        , perkClassToPerks
        ]


perkClassTests : Test
perkClassTests =
    [ ( Aggression, "Aggression" )
    , ( Badass, "Badass" )
    , ( Daring, "Daring" )
    , ( Military, "Military" )
    , ( Precision, "Precision" )
    , ( Speed, "Speed" )
    , ( Technology, "Technology" )
    , ( PrisonCars, "PrisonCars" )
    , ( Tuning, "Tuning" )
    , ( Pursuit, "Pursuit" )
    ]
        |> List.map
            (\( perkClass, expected ) ->
                test ("perkClass comparison test: " ++ fromPerkClass perkClass) <|
                    \_ ->
                        perkClass
                            |> fromPerkClass
                            |> Expect.equal expected
            )
        |> describe "perk class tests"


perkClassToPerks : Test
perkClassToPerks =
    [ ( Aggression, aggression )
    , ( Badass, badass )
    , ( Daring, daring )
    , ( Military, military )
    , ( Precision, precision )
    , ( Speed, speed )
    , ( Technology, technology )
    , ( PrisonCars, prisonCars )
    , ( Tuning, tuning )
    , ( Pursuit, pursuit )
    ]
        |> List.map
            (\( perkClass, expected ) ->
                test ("perkClass to perk list: " ++ fromPerkClass perkClass) <|
                    \_ ->
                        perkClass
                            |> getClassPerks
                            |> Expect.equal expected
            )
        |> describe "perk class -> perk list"
