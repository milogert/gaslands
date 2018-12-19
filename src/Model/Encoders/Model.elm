module Model.Encoders.Model exposing (modelEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Sponsors exposing (sponsorEncoder, sponsorTypeEncoder)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Model exposing (Model)


modelEncoder : Model -> Value
modelEncoder model =
    let
        sponsor =
            case model.sponsor of
                Nothing ->
                    null

                Just s ->
                    sponsorTypeEncoder s
    in
    object
        [ ( "pointsAllowed", int model.pointsAllowed )
        , ( "teamName", teamNameEncoder model.teamName )
        , ( "vehicles", list object <| List.map vehicleEncoder model.vehicles )
        , ( "sponsor", sponsor )
        ]


teamNameEncoder : Maybe String -> Value
teamNameEncoder ms =
    case ms of
        Nothing ->
            null

        Just s ->
            string s
