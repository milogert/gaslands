module Model.Decoders.Sponsors exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Sponsors exposing (..)


sponsorDecoder : Decoder Sponsor
sponsorDecoder =
    decode Sponsor
        |> required "name" (D.string |> D.andThen sponsorTypeDecoderHelper)
        |> required "description" D.string
        |> required "perks" (D.list teamPerkDecoder)
        |> required "grantedClasses" (D.list (D.string |> D.andThen perkClassDecoderHelper))


sponsorTypeDecoderHelper : String -> Decoder SponsorType
sponsorTypeDecoderHelper s =
    case s of
        "Rutherford" ->
            D.succeed Rutherford

        "Miyazaki" ->
            D.succeed Miyazaki

        "Mishkin" ->
            D.succeed Mishkin

        "Idris" ->
            D.succeed Idris

        "Slime" ->
            D.succeed Slime

        "Warden" ->
            D.succeed Warden

        _ ->
            D.fail <| s ++ " is not a valid weapon type"


teamPerkDecoder : Decoder TeamPerk
teamPerkDecoder =
    decode TeamPerk
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
    decode VehiclePerk
        |> required "name" D.string
        |> required "cost" D.int
        |> required "description" D.string
