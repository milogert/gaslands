module Subscriptions.Subscriptions exposing (subscriptions)

import Model.Model exposing (..)
import Model.Vehicle.Model exposing (..)
import Ports.Photo
import Ports.Storage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.Storage.getStorageSub GetAllStorage
        , Ports.Storage.getSub GetStorage
        , Ports.Storage.setSub SetStorageCallback
        , Ports.Storage.deleteSub DeleteItemCallback
        , Ports.Storage.getLastTeamSub GetLastTeamCallback
        , Ports.Storage.setLastTeamSub SetLastTeamCallback
        , Ports.Photo.getPhotoUrl <| VehicleMsg << SetPhotoUrlCallback
        ]
