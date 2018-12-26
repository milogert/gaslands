module Model.Decoders.Vehicles exposing (gearDecoder, hullDecoder, skidResultDecoder, skidResultHelper, vehicleDecoder, vtypeDecoder, weightDecoder)

import Json.Decode exposing (Decoder, andThen, bool, fail, int, list, nullable, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Shared exposing (..)
import Model.Decoders.Sponsors exposing (..)
import Model.Decoders.Upgrades exposing (..)
import Model.Decoders.Weapons exposing (..)
import Model.Vehicles exposing (..)


vehicleDecoder : Decoder Vehicle
vehicleDecoder =
    succeed Vehicle
        |> required "name" string
        |> optional "photo" (nullable string) Nothing
        |> required "vtype" vtypeDecoder
        |> required "gear" gearDecoder
        |> hardcoded 0
        |> required "handling" int
        --|> required "skidResults" (list skidResultDecoder)
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


vtypeDecoder : Decoder VehicleType
vtypeDecoder =
    string
        |> andThen
            (\str ->
                let
                    vtype =
                        strToVT str
                in
                case vtype of
                    Just vt ->
                        succeed vt

                    Nothing ->
                        fail <| str ++ " is not a valid vehicle type"
            )


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

                    "Ariborne" ->
                        succeed Airborne

                    _ ->
                        fail <| str ++ " is not a valid weight."
            )


hullDecoder : Decoder HullHolder
hullDecoder =
    succeed HullHolder
        |> hardcoded 0
        |> required "max" int


skidResultDecoder : Decoder SkidResult
skidResultDecoder =
    string
        |> andThen skidResultHelper


skidResultHelper : String -> Decoder SkidResult
skidResultHelper s =
    case s of
        "Hazard" ->
            succeed Hazard

        "Spin" ->
            succeed Spin

        "Slide" ->
            succeed Slide

        "Shift" ->
            succeed Shift

        _ ->
            fail <| s ++ " is not a valid skid result."
