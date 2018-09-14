module Subscriptions.Subscriptions exposing (subscriptions)

import Model.Model exposing (..)
import Ports.Storage
import Ports.Photo


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.Storage.getSub GetStorage
        , Ports.Storage.getKeysSub GetStorageKeys
        , Ports.Storage.setSub SetStorageCallback
        , Ports.Storage.deleteSub DeleteItemCallback
        , Ports.Photo.getPhotoUrl SetPhotoUrlCallback
        ]
