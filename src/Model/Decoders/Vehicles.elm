module Model.Decoders.Vehicles exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Vehicles exposing (..)
import Model.Decoders.Weapons exposing (..)
import Model.Decoders.Upgrades exposing (..)


vehicleDecoder : Decoder Vehicle
vehicleDecoder =
    decode Vehicle
        |> required "name" D.string
        |> required "vtype" vtypeDecoder
        |> required "gear" gearDecoder
        |> required "handling" D.int
        |> required "hull" hullDecoder
        |> required "crew" D.int
        |> required "equipment" D.int
        |> required "weight" weightDecoder
        |> required "activated" D.bool
        |> required "weapons" (D.list weaponDecoder)
        |> required "upgrades" (D.list upgradeDecoder)
        |> required "notes" D.string
        |> required "cost" D.int
        |> required "id" D.int


vtypeDecoder : Decoder VehicleType
vtypeDecoder =
    D.string
        |> D.andThen (\str ->
            let
                vtype =
                    strToVT str
            in
                case vtype of
                    Just vt -> D.succeed vt
                    Nothing -> D.fail <| str ++ " is not a valid vehicle type"
        )


gearDecoder : Decoder GearTracker
gearDecoder =
    decode GearTracker
        |> hardcoded 0
        |> required "max" D.int


weightDecoder : Decoder WeightClass
weightDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Light" -> D.succeed Light
                "Middle" -> D.succeed Middle
                "Heavy" -> D.succeed Heavy
                "Ariborne" -> D.succeed Airborne
                _ -> D.fail <| str ++ " is not a valid weight."
        )


hullDecoder : Decoder HullHolder
hullDecoder =
    decode HullHolder
        |> hardcoded 0
        |> required "max" D.int



