module Model.Decoders.Sponsors exposing
    ( perkClassDecoderHelper
    , sponsorDecoder
    , teamPerkDecoder
    , vehiclePerkDecoder
    )

import Json.Decode as D exposing (Decoder, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Model.Decoders.Shared exposing (expansionDecoder)
import Model.Sponsors exposing (..)


sponsorDecoder : Decoder Sponsor
sponsorDecoder =
    succeed Sponsor
        |> required "name" D.string
        |> required "description" D.string
        |> required "perks" (D.list teamPerkDecoder)
        |> required "grantedClasses" (D.list (D.string |> D.andThen perkClassDecoderHelper))
        |> required "expansion" expansionDecoder


teamPerkDecoder : Decoder TeamPerk
teamPerkDecoder =
    succeed TeamPerk
        |> required "name" D.string
        |> required "description" D.string


perkClassDecoderHelper : String -> Decoder PerkClass
perkClassDecoderHelper s =
    case s of
        "Aggression" ->
            D.succeed Aggression

        "Badass" ->
            D.succeed Badass

        "Daring" ->
            D.succeed Daring

        "Military" ->
            D.succeed Military

        "Precision" ->
            D.succeed Precision

        "Speed" ->
            D.succeed Speed

        "Technology" ->
            D.succeed Technology

        "PrisonCars" ->
            D.succeed PrisonCars

        _ ->
            D.fail <| s ++ " is not a valid perk class."


vehiclePerkDecoder : Decoder VehiclePerk
vehiclePerkDecoder =
    succeed VehiclePerk
        |> required "name" D.string
        |> required "cost" D.int
        |> required "description" D.string
