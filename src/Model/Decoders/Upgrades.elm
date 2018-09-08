module Model.Decoders.Upgrades exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Decoders.Shared exposing (specialDecoder)
import Model.Upgrades exposing (Upgrade)


upgradeDecoder : Decoder Upgrade
upgradeDecoder =
    decode Upgrade
        |> required "name" D.string
        |> required "slots" D.int
        |> required "specials" (D.list specialDecoder)
        |> required "cost" D.int
        |> required "id" D.int
