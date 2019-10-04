module Model.Decoders.Model exposing (modelDecoder)

import Bootstrap.Modal as Modal
import Browser.Navigation as Nav
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Model.Decoders.Settings exposing (settingsDecoder)
import Model.Decoders.Sponsors exposing (sponsorDecoder)
import Model.Decoders.Vehicles exposing (vehicleDecoder)
import Model.Model exposing (..)
import Model.Routes exposing (Route(..))
import Model.Sponsors exposing (stringToSponsor)
import Url exposing (Url)


modelDecoder : Decoder (Url -> Nav.Key -> Model)
modelDecoder =
    succeed Model
        |> hardcoded RouteDashboard
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
        |> required "settings" settingsDecoder
