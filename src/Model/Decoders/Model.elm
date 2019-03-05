module Model.Decoders.Model exposing (modelDecoder)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Settings exposing (settingsDecoder)
import Model.Decoders.Sponsors exposing (sponsorDecoder, sponsorTypeDecoderHelper)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Model exposing (..)


modelDecoder : Decoder Model
modelDecoder =
    succeed Model
        |> hardcoded ViewDashboard
        |> optional "teamName" (nullable string) Nothing
        |> required "pointsAllowed" int
        |> hardcoded 1
        |> required "vehicles" (dict vehicleDecoder)
        |> optional "sponsor" (nullable (string |> andThen sponsorTypeDecoderHelper)) Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded []
        |> hardcoded ""
        |> hardcoded []
        |> required "settings" settingsDecoder
