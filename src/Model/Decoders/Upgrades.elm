module Model.Decoders.Upgrades exposing (upgradeDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Model.Decoders.Shared exposing (expansionDecoder, specialDecoder)
import Model.Upgrade.Model exposing (Upgrade)


upgradeDecoder : Decoder Upgrade
upgradeDecoder =
    D.succeed Upgrade
        |> required "name" D.string
        |> required "slots" D.int
        |> required "specials" (D.list specialDecoder)
        |> required "cost" D.int
        |> required "expansion" expansionDecoder
