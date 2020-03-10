module Model.TestUtils exposing (suite)

import Expect
import Model.Upgrade.Common
import Model.Vehicle exposing (defaultVehicle)
import Model.Vehicle.Common exposing (totalCrew, totalGear, totalHandling, totalHull, totalSlots)
import Test exposing (Test, describe, test)


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
                Expect.equal 4 <| totalHull v
        , test "total gear for vehicle" <|
            \_ ->
                Expect.equal 1 <| totalGear v
        , test "total crew for vehicle" <|
            \_ ->
                Expect.equal 1 <| totalCrew v
        , test "total slots for vehicle" <|
            \_ ->
                Expect.equal 4 <| totalSlots v
        ]
