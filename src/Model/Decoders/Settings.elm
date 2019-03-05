module Model.Decoders.Settings exposing (settingsDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Shared exposing (expansionDecoder)
import Model.Settings exposing (..)


settingsDecoder : Decoder Settings
settingsDecoder =
    D.succeed Settings
        |> required "percentVehicles" D.int
        |> required "percentWeapons" D.int
        |> required "percentUpgrades" D.int
        |> required "percentPerks" D.int
        |> required "pointsAllowed" D.int
        |> optional "spinResults" (D.list spinResultDecoder) []
        |> required "expansions" expansionTrackerDecoder


spinResultDecoder : Decoder SpinResult
spinResultDecoder =
    D.succeed SpinResult
        |> required "summary" D.string
        |> required "cost" D.int


expansionTrackerDecoder : Decoder ExpansionTracker
expansionTrackerDecoder =
    D.succeed ExpansionTracker
        |> required "enabled" (D.list expansionDecoder)
        |> required "available" (D.list expansionDecoder)
