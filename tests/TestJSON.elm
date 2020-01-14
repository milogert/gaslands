module TestJSON exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeValue, errorToString)
import Json.Encode
import Model.Decoders.Model exposing (modelDecoder)
import Model.Decoders.Upgrades exposing (upgradeDecoder)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Decoders.Weapons exposing (weaponDecoder)
import Model.Encoders.Model exposing (modelEncoder)
import Model.Encoders.Upgrades exposing (upgradeEncoder)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Encoders.Weapons exposing (weaponEncoder)
import Model.Model exposing (defaultModel)
import Model.Sponsors exposing (allSponsors)
import Model.Upgrade exposing (Upgrade, defaultUpgrade)
import Model.Vehicle exposing (defaultVehicle)
import Model.Weapon exposing (defaultWeapon)
import Test exposing (..)


suite : Test
suite =
    describe "Encode/Decode tests"
        [ test "model encodes and decodes are the same" <|
            \_ ->
                let
                    expected =
                        { defaultModel
                            | sponsor = List.head allSponsors
                        }

                    decodedActual =
                        expected
                            |> modelEncoder
                            |> decodeValue modelDecoder
                in
                expectEncodeDecode expected decodedActual
        , test "vehicle encodes and decodes are the same" <|
            \_ ->
                let
                    expected =
                        defaultVehicle

                    decodedActual =
                        expected
                            |> vehicleEncoder
                            |> decodeValue vehicleDecoder
                in
                expectEncodeDecode expected decodedActual
        , test "weapon encodes and decodes are the same" <|
            \_ ->
                let
                    expected =
                        defaultWeapon

                    decodedActual =
                        expected
                            |> weaponEncoder
                            |> Json.Encode.object
                            |> decodeValue weaponDecoder
                in
                expectEncodeDecode expected decodedActual
        , test "upgrade encodes and decodes are the same" <|
            \_ ->
                let
                    expected =
                        defaultUpgrade

                    decodedActual =
                        expected
                            |> upgradeEncoder
                            |> Json.Encode.object
                            |> decodeValue upgradeDecoder
                in
                expectEncodeDecode expected decodedActual
        ]


expectEncodeDecode : a -> Result Json.Decode.Error a -> Expect.Expectation
expectEncodeDecode expected decodedActual =
    case decodedActual of
        Ok value ->
            Expect.equal expected value

        Err error ->
            Expect.fail <| "Failed to decode: " ++ errorToString error
