module Update.TestSponsor exposing (suite)

import Expect exposing (Expectation)
import Model.Model exposing (defaultModel)
import Model.Sponsors exposing (SponsorType(..))
import Test exposing (..)
import Update.Sponsor


suite : Test
suite =
    describe "all sponsor tests"
        [ test "set" <|
            \_ ->
                Rutherford
                    |> Just
                    |> Update.Sponsor.set defaultModel
                    |> Tuple.first
                    |> .sponsor
                    |> Expect.equal (Just Rutherford)
        ]
