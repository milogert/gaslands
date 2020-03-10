module Model.Encoders.Model exposing (modelEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Settings exposing (settingsEncoder)
import Model.Encoders.Sponsors exposing (sponsorEncoder)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Model exposing (Model)


modelEncoder : Model -> Value
modelEncoder model =
    object
        [ ( "pointsAllowed", int model.pointsAllowed )
        , ( "teamName", teamNameEncoder model.teamName )
        , ( "vehicles", dict identity vehicleEncoder model.vehicles )
        , ( "sponsor", sponsorEncoder model.sponsor )
        , ( "settings", object <| settingsEncoder model.settings )
        , ( "storageKey", string model.storageKey )
        ]


teamNameEncoder : Maybe String -> Value
teamNameEncoder ms =
    case ms of
        Nothing ->
            null

        Just s ->
            string s
