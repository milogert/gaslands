module Update.TestVehicle exposing (suite)

import Dict
import Expect exposing (Expectation)
import Json.Decode exposing (decodeValue, errorToString)
import Json.Encode
import List.Extra as ListE
import Model.Model exposing (Model, Msg, defaultModel)
import Model.Sponsors exposing (VehiclePerk)
import Model.Upgrade.Model exposing (Upgrade, defaultUpgrade)
import Model.Vehicle.Model
    exposing
        ( Vehicle
        , VehicleEvent(..)
        , VehicleType(..)
        , defaultVehicle
        )
import Model.Weapon.Model exposing (defaultWeapon)
import Test exposing (..)
import Update.Vehicle exposing (update)


suite : Test
suite =
    describe "all vehicle tests" <|
        crud
            :: tmpVehicleTests
            :: updateShiftGearHazardsHull
            :: miscUpdates
            :: []


crud : Test
crud =
    describe "Vehicle correctness tests"
        [ test "vehicle with no name never gets added" <|
            \_ ->
                let
                    model =
                        defaultModel

                    vehicle =
                        defaultVehicle

                    updated =
                        Tuple.first <| update model (AddVehicle vehicle)

                    predicate =
                        (List.length updated.error == 1)
                            && (List.head updated.error == Just Model.Model.VehicleNameError)
                            && (Dict.size updated.vehicles == 0)
                in
                Expect.true
                    "updated model should have no vehicles and one error"
                    predicate
        , test "adding a vehicle"
            (\_ ->
                let
                    model =
                        defaultModel

                    key =
                        "test0"

                    vehicle =
                        { defaultVehicle
                            | name = "test"
                            , key = key
                        }

                    updated =
                        Tuple.first <| update model (AddVehicle vehicle)
                in
                Expect.equal
                    (Just vehicle)
                    (Dict.get key updated.vehicles)
            )
        , test "delete a vehicle"
            (\_ ->
                let
                    model =
                        defaultModel

                    key =
                        "test0"

                    vehicle =
                        { defaultVehicle
                            | name = "test"
                            , key = key
                        }

                    updated =
                        Tuple.first <| update model (AddVehicle vehicle)

                    removed =
                        Tuple.first <| update model (DeleteVehicle key)
                in
                Expect.equal
                    Nothing
                    (Dict.get key removed.vehicles)
            )
        ]


tmpVehicleTests : Test
tmpVehicleTests =
    let
        modelTmp =
            { defaultModel | tmpVehicle = Just defaultVehicle }

        modelNoTmp =
            defaultModel

        updateFunc =
            Update.Vehicle.update
    in
    describe "temporary vehicle" <|
        [ test "name with temporary vehicle" <|
            \_ ->
                let
                    updated =
                        updateFunc modelTmp (TmpName "test")

                    vehicle =
                        Maybe.withDefault defaultVehicle (Tuple.first updated).tmpVehicle
                in
                Expect.equal
                    "test"
                    vehicle.name
        , test "name with no temporary vehicle" <|
            \_ ->
                let
                    updated =
                        updateFunc modelNoTmp (TmpName "test")

                    vehicle =
                        updated |> Tuple.first |> .tmpVehicle
                in
                Expect.equal
                    Nothing
                    vehicle
        , test "type" <|
            \_ ->
                let
                    updated =
                        updateFunc modelTmp (TmpVehicleType "2")

                    vehicle =
                        updated
                            |> Tuple.first
                            |> .tmpVehicle
                            |> Maybe.withDefault defaultVehicle
                in
                Expect.equal
                    Car
                    vehicle.vtype
        , test "notes" <|
            \_ ->
                let
                    updated =
                        updateFunc modelTmp (TmpNotes "Test Notes")

                    vehicle =
                        updated
                            |> Tuple.first
                            |> .tmpVehicle
                            |> Maybe.withDefault defaultVehicle
                in
                Expect.equal
                    "Test Notes"
                    vehicle.notes
        ]


updateShiftGearHazardsHull : Test
updateShiftGearHazardsHull =
    let
        v =
            defaultVehicle

        k =
            "key"

        modelV =
            { defaultModel | vehicles = Dict.fromList [ ( k, v ) ] }

        modelNV =
            defaultModel
    in
    describe "update and shift tests for gear, hazards, hull"
        [ describe "gear"
            [ test "shift correct with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftGear k 1 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .gear
                                |> .current
                    in
                    Expect.equal 2 actualShifted
            , test "shift incorrect with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftGear k -100 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .gear
                                |> .current
                    in
                    Expect.equal 1 actualShifted
            , test "shift with no vehicle" <|
                \_ ->
                    let
                        noVehicle =
                            u2v modelNV (ShiftGear k -100 1 6) k
                    in
                    Expect.equal Nothing noVehicle
            ]
        , describe "hazards"
            [ test "shift correct with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftHazards k 2 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .hazards
                    in
                    Expect.equal 2 actualShifted
            , test "shift incorrect with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftHazards k -100 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .hazards
                    in
                    Expect.equal 1 actualShifted
            , test "shift with no vehicle" <|
                \_ ->
                    let
                        noVehicle =
                            u2v modelNV (ShiftHazards k -100 1 6) k
                    in
                    Expect.equal Nothing noVehicle
            ]
        , describe "hull"
            [ test "shift correct with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftHull k 2 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .hull
                                |> .current
                    in
                    Expect.equal 2 actualShifted
            , test "shift incorrect with vehicle" <|
                \_ ->
                    let
                        actualShifted =
                            u2v modelV (ShiftHull k -100 1 6) k
                                |> Maybe.withDefault defaultVehicle
                                |> .hull
                                |> .current
                    in
                    Expect.equal 1 actualShifted
            , test "shift with no vehicle" <|
                \_ ->
                    let
                        noVehicle =
                            u2v modelNV (ShiftHull k -100 1 6) k
                    in
                    Expect.equal Nothing noVehicle
            ]
        ]


miscUpdates : Test
miscUpdates =
    let
        v =
            defaultVehicle

        k =
            "key"

        model =
            { defaultModel | vehicles = Dict.fromList [ ( k, v ) ] }
    in
    describe "misc update tests"
        [ test "crew" <|
            \_ ->
                u2v model (UpdateCrew k "2") k
                    |> Maybe.withDefault defaultVehicle
                    |> .crew
                    |> Expect.equal 2
        , test "equipment" <|
            \_ ->
                u2v model (UpdateEquipment k "2") k
                    |> Maybe.withDefault defaultVehicle
                    |> .equipment
                    |> Expect.equal 2
        , test "notes" <|
            \_ ->
                u2v model (UpdateNotes k "blahblah") k
                    |> Maybe.withDefault defaultVehicle
                    |> .notes
                    |> Expect.equal "blahblah"
        , test "perk" <|
            \_ ->
                u2v model (SetPerkInVehicle k (VehiclePerk "test" 1 "desc") True) k
                    |> Maybe.withDefault defaultVehicle
                    |> .perks
                    |> List.head
                    |> Maybe.withDefault (VehiclePerk "" 0 "")
                    |> Expect.equal
                        (VehiclePerk "test" 1 "desc")
        ]


u2v : Model -> VehicleEvent -> String -> Maybe Vehicle
u2v model msg key =
    update model msg
        |> Tuple.first
        |> .vehicles
        |> Dict.get key
