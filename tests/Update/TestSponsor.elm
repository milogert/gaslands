module Update.TestSponsor exposing (suite)

import Expect exposing (Expectation)
import Model.Model exposing (defaultModel)
import Model.Sponsors exposing (allSponsors, stringToSponsor)
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
        ]
