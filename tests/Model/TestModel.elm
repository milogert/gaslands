module Model.TestModel exposing (suite)

import Dict exposing (..)
import Expect exposing (Expectation)
import Json.Decode exposing (decodeValue, errorToString)
import Json.Encode
import Model.Model exposing (..)
import Model.Vehicle.Common exposing (allVehicles)
import Model.Vehicle.Model exposing (VehicleType(..), defaultVehicle)
import Model.Views exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Model tests" <|
        [ test "init" <| \_ -> Expect.equal ( defaultModel, Cmd.none ) (init ())
        , totalPointsTest

        --, viewTests
        , errorTests
        ]


totalPointsTest : Test
totalPointsTest =
    [ ( { defaultModel
            | teamName = Just "default"
        }
      , 0
      )
    , ( { defaultModel
            | teamName = Just "one bike vehicle"
            , vehicles =
                Dict.fromList
                    [ ( ""
                      , allVehicles
                            |> List.filter (\v -> v.vtype == Bike)
                            |> List.head
                            |> Maybe.withDefault defaultVehicle
                      )
                    ]
        }
      , 5
      )
    ]
        |> List.map
            (\( model, expected ) ->
                test ("total points: " ++ Maybe.withDefault "bad name" model.teamName) <|
                    \_ -> model |> totalPoints |> Expect.equal expected
            )
        |> describe "total points test"


viewTests : Test
viewTests =
    [ ( ViewDashboard, "Team NoName" )
    , ( ViewDetails defaultVehicle.key, "" )
    ]
        |> List.map
            (\( view, result ) ->
                test ("view test: " ++ result) <|
                    \_ ->
                        viewToStr { defaultModel | view = view }
                            |> Expect.equal result
            )
        |> describe "View2str tests"


errorTests : Test
errorTests =
    [ ( VehicleNameError, "Vehicle requires a name." )
    , ( VehicleTypeError, "Vehicle requires a type." )
    , ( WeaponTypeError, "Select a weapon from the dropdown to add." )
    , ( WeaponMountPointError, "Select a mount point from the dropdown." )
    , ( UpgradeTypeError, "Select an upgrade from the dropdown to add." )
    , ( JsonDecodeError "blah", "Json decode error: blah" )
    ]
        |> List.map
            (\( error, result ) ->
                test ("error test: " ++ result) <|
                    \_ ->
                        errorToStr error
                            |> Expect.equal result
            )
        |> describe "error2str tests"
