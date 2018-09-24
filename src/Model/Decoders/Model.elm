module Model.Decoders.Model exposing (modelDecoder)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Decoders.Sponsors exposing (sponsorTypeDecoderHelper, sponsorDecoder)
import Model.Model exposing (..)


modelDecoder : Decoder Model
modelDecoder =
    decode Model
        |> hardcoded Overview
        |> optional "teamName" (nullable string) Nothing
        |> required "pointsAllowed" int
        |> hardcoded 0
        |> required "vehicles" (list vehicleDecoder)
        |> optional "sponsor" (nullable (string |> andThen sponsorTypeDecoderHelper)) Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded []
        |> hardcoded ""
        |> hardcoded []
