module Model.Encoders.Model exposing (modelEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Model exposing (Model)


modelEncoder : Model -> Value
modelEncoder model =
    object
        [ ( "pointsAllowed", int model.pointsAllowed )
        , ( "teamName", teamNameEncoder model.teamName )
        , ( "vehicles", list <| List.map vehicleEncoder model.vehicles )
        ]


teamNameEncoder : Maybe String -> Value
teamNameEncoder ms =
    case ms of
        Nothing ->
            null

        Just s ->
            string s
