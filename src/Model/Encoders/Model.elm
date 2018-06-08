module Model.Encoders.Model exposing (modelEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Vehicles exposing (vehicleEncoder)
import Model.Model exposing (Model)


modelEncoder : Model -> Value
modelEncoder model =
    object 
        [ ("pointsAllowed", int model.pointsAllowed)
        , ("vehicles", list <| List.map vehicleEncoder model.vehicles)
        ]

