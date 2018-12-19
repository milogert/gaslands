module Model.Decoders.Settings exposing (settingsDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Settings exposing (..)


settingsDecoder : Decoder Settings
settingsDecoder =
    D.fail "Not implemented"
