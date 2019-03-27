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

        ViewSelectingSponsor ->
            ( { model | view = ViewSelectingSponsor }
            , Cmd.none
            )

        ViewAddingVehicle ->
            ( { model | view = ViewAddingVehicle, tmpVehicle = Nothing }
            , Cmd.none
            )

        ViewAddingWeapon v ->
            ( { model | view = ViewAddingWeapon v, tmpWeapon = Nothing }
            , Cmd.none
            )

        ViewAddingUpgrade v ->
            ( { model | view = ViewAddingUpgrade v, tmpUpgrade = Nothing }
            , Cmd.none
            )

        ViewSettings ->
            ( { model | view = ViewSettings }
            , Ports.Storage.getKeys ""
            )

        ViewPrinterFriendly v ->
            ( { model | view = ViewPrinterFriendly v }
            , Cmd.none
            )
