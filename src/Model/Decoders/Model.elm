module Model.Decoders.Model exposing (modelDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Model exposing (..)


modelDecoder : Decoder Model
modelDecoder =
    decode Model
        |> hardcoded Overview
        |> required "pointsAllowed" D.int
        |> required "vehicles" (D.list vehicleDecoder)
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded []
        |> hardcoded ""
    
