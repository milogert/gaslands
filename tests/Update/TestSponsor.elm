module Update.TestSponsor exposing (suite)

import Dict
import Expect exposing (Expectation)
import Model.Model exposing (Msg(..), defaultModel)
import Model.Sponsors exposing (VehiclePerk, allSponsors, stringToSponsor)
import Model.Vehicle.Model exposing (defaultVehicle)
import Test exposing (..)
import Update.Update


suite : Test
suite =
    todo "undo delete"



{- describe "all sponsor tests"
   [ test "set" <|
       \_ ->
           Update.Update.update (SponsorUpdate "Rutherford") defaultModel
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
           Update.Update.update (SponsorUpdate "Rutherford") model
               |> Tuple.first
               |> .vehicles
               |> Dict.get "test"
               |> Maybe.withDefault { defaultVehicle | perks = [ VehiclePerk "should" -1 "not be present" ] }
               |> .perks
               |> Expect.equal []
   ]
-}
