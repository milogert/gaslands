module Model.Decoders.Vehicles exposing
    ( gearDecoder
    , hullDecoder
    , vehicleDecoder
    , weightDecoder
    )

import Json.Decode exposing (Decoder, andThen, bool, fail, int, list, nullable, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Shared exposing (..)
import Model.Decoders.Sponsors exposing (..)
import Model.Decoders.Upgrades exposing (..)
import Model.Decoders.Weapons exposing (..)
import Model.Vehicle exposing (..)
import Model.Vehicle.Common exposing (..)


vehicleDecoder : Decoder Vehicle
vehicleDecoder =
    succeed Vehicle
        |> required "name" string
        |> required "category" (string |> andThen categoryDecoderHelper)
        |> optional "photo" (nullable string) Nothing
        |> required "type_" string
        |> required "gear" gearDecoder
        |> hardcoded 0
        |> required "handling" int
        |> hardcoded []
        |> required "hull" hullDecoder
        |> required "crew" int
        |> required "equipment" int
        |> required "weight" weightDecoder
        |> required "activated" bool
        |> required "weapons" (list weaponDecoder)
        |> required "upgrades" (list upgradeDecoder)
        |> required "notes" string
        |> required "cost" int
        |> required "key" string
        |> required "specials" (list specialDecoder)
        |> required "perks" (list vehiclePerkDecoder)
        |> optional "requiredSponsor" (string |> andThen requiredSponsorDecoderHelper) Nothing


gearDecoder : Decoder GearTracker
gearDecoder =
    succeed GearTracker
        |> hardcoded 1
        |> required "max" int


weightDecoder : Decoder WeightClass
weightDecoder =
    string
        |> andThen
            (\str ->
                case str of
                    "Light" ->
                        succeed Light

                    "Middle" ->
                        succeed Middle

                    "Heavy" ->
                        succeed Heavy

                    _ ->
                        fail <| str ++ " is not a valid weight."
            )


hullDecoder : Decoder HullHolder
hullDecoder =
    succeed HullHolder
        |> hardcoded 0
        |> required "max" int
