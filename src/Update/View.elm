module Update.View exposing (update)

import Model.Model exposing (..)
import Ports.Photo
import Ports.Storage
import Update.Utils exposing (doSaveModel)


update : Model -> CurrentView -> ( Model, Cmd Msg )
update model currentView =
    case currentView of
        ViewDashboard ->
            ( { model
                | view = ViewDashboard
                , tmpVehicle = Nothing
                , tmpWeapon = Nothing
                , tmpUpgrade = Nothing
              }
            , doSaveModel
            )

        ViewDetails v ->
            ( { model | view = ViewDetails v }
            , Cmd.batch
                [ Ports.Photo.destroyStream ""
                , doSaveModel
                ]
            )

        ViewPrinterFriendly v ->
            ( { model | view = ViewPrinterFriendly v }
            , Cmd.none
            )
