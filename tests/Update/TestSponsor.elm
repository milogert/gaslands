module Update.TestSponsor exposing (suite)

import Dict
import Expect exposing (Expectation)
import Model.Model exposing (defaultModel)
import Model.Sponsors exposing (VehiclePerk, allSponsors, stringToSponsor)
import Model.Vehicle.Model exposing (defaultVehicle)
import Test exposing (..)
import Update.Sponsor


suite : Test
suite =
    describe "all sponsor tests"
        [ test "set" <|
            \_ ->
                stringToSponsor "Rutherford"
                    |> Update.Sponsor.set defaultModel
                    |> Tuple.first
                    |> .sponsor
                    |> Expect.equal (stringToSponsor "Rutherford")
        , test "clears perks" <|
            \_ ->
                let
                    vehicle =
                        { defaultVehicle | perks = [ VehiclePerk "test" 0 "desc" ] }

                    model =
                        { defaultModel | vehicles = Dict.fromList [ ( "test", vehicle ) ] }
                in
                stringToSponsor "Rutherford"
                    |> Update.Sponsor.set model
                    |> Tuple.first
                    |> .vehicles
                    |> Dict.get "test"
                    |> Maybe.withDefault { defaultVehicle | perks = [ VehiclePerk "should" -1 "not be present" ] }
                    |> .perks
                    |> Expect.equal []
        ]
