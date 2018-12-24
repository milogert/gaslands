module Update.Data exposing (import_, saveModel, share)

import Json.Decode
import Json.Encode
import Model.Decoders.Model exposing (modelDecoder)
import Model.Encoders.Model exposing (modelEncoder)
import Model.Model exposing (..)
import Ports.Storage


import_ : Model -> ( Model, Cmd Msg )
import_ model =
    let
        decodeRes =
            Json.Decode.decodeString modelDecoder model.importValue

        newModel : Model
        newModel =
            case decodeRes of
                Ok m ->
                    m

                Err s ->
                    { model | error = [ JsonDecodeError <| Json.Decode.errorToString s ] }
    in
    ( { model
        | view = newModel.view
        , teamName = newModel.teamName
        , pointsAllowed = newModel.pointsAllowed
        , vehicles = newModel.vehicles
        , tmpVehicle = newModel.tmpVehicle
        , tmpWeapon = newModel.tmpWeapon
        , tmpUpgrade = newModel.tmpUpgrade
        , error = newModel.error
        , importValue = newModel.importValue
        , sponsor = newModel.sponsor
      }
    , Cmd.none
    )


share : Model -> ( Model, Cmd Msg )
share model =
    let
        value =
            Json.Encode.encode 2 <| modelEncoder model
    in
    ( { model | importValue = value }
    , Ports.Storage.share value
    )



-- SAVING/LOADING.


saveModel : Model -> ( Model, Cmd Msg )
saveModel model =
    let
        storageKey =
            case model.teamName of
                Nothing ->
                    "NoName"

                Just str ->
                    str

        storageEntry =
            Ports.Storage.StorageEntry
                storageKey
                (Json.Encode.encode 2 <| modelEncoder model)
    in
    ( model
    , Ports.Storage.set storageEntry
    )
