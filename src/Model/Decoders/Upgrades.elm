module Model.Decoders.Upgrades exposing (upgradeDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Model.Decoders.Shared exposing (..)
import Model.Upgrade exposing (Upgrade)


upgradeDecoder : Decoder Upgrade
upgradeDecoder =
    D.succeed Upgrade
        |> required "name" D.string
        |> required "slots" D.int
        |> required "specials" (D.list specialDecoder)
        |> required "cost" D.int
        |> optional "requiredSponsor" (D.string |> D.andThen requiredSponsorDecoderHelper) Nothing
