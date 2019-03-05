module Model.TestUtils exposing (suite)

import Expect exposing (Expectation)
import Model.Shared exposing (..)
import Model.Upgrade.Common
import Model.Utils exposing (..)
import Model.Vehicle.Model exposing (defaultVehicle)
import Test exposing (..)


suite : Test
suite =
    let
        v =
            { defaultVehicle
                | upgrades = Model.Upgrade.Common.allUpgradesList
            }
    in
    describe "Model.Utils tests" <|
        [ test "total handling for vehicle" <|
            \_ ->
                Expect.equal 1 <| totalHandling v
        , test "total hull for vehicle" <|
            \_ ->
                Expect.equal 2 <| totalHull v
        , test "total gear for vehicle" <|
            \_ ->
                Expect.equal 1 <| totalGear v
        , test "total crew for vehicle" <|
            \_ ->
                Expect.equal 1 <| totalCrew v
        ]
