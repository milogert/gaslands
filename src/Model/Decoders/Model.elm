module Model.Decoders.Model exposing (modelDecoder)

import Browser.Navigation as Nav
import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Settings exposing (settingsDecoder)
import Model.Decoders.Sponsors exposing (sponsorDecoder)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Features
import Model.Model exposing (..)
import Model.Sponsors exposing (stringToSponsor)
import Model.Views exposing (ViewEvent(..))
import Url exposing (Url)


modelDecoder : Decoder Model
modelDecoder =
    succeed Model
        |> hardcoded False
        |> hardcoded ViewDashboard
        |> hardcoded Nothing
        |> optional "teamName" (nullable string) Nothing
        |> required "pointsAllowed" int
        |> hardcoded 1
        |> required "vehicles" (dict vehicleDecoder)
        |> optional "sponsor" (nullable sponsorDecoder) Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> hardcoded []
        |> hardcoded ""
        |> hardcoded []
        |> hardcoded Dict.empty
        |> required "settings" settingsDecoder
        |> hardcoded Model.Features.flags
