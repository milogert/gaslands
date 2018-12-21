module Subscriptions.Subscriptions exposing (subscriptions)

import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Ports.Photo
import Ports.Storage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.Storage.getSub GetStorage
        , Ports.Storage.getKeysSub GetStorageKeys
        , Ports.Storage.setSub SetStorageCallback
        , Ports.Storage.deleteSub DeleteItemCallback
        , Ports.Photo.getPhotoUrl <| VehicleMsg << SetPhotoUrlCallback
        ]
