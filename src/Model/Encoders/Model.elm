module Model.Encoders.Model exposing (modelEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Encoders.Sponsors exposing (sponsorEncoder)
import Model.Model exposing (Model)


modelEncoder : Model -> Value
modelEncoder model =
    object
        [ ( "pointsAllowed", int model.pointsAllowed )
        , ( "teamName", teamNameEncoder model.teamName )
        , ( "vehicles", list <| List.map vehicleEncoder model.vehicles )
        , ( "sponsor", sponsorEncoder model.sponsor )
        ]


teamNameEncoder : Maybe String -> Value
teamNameEncoder ms =
    case ms of
        Nothing ->
            null

        Just s ->
            string s
