module Update.View exposing (update)

import Model.Model exposing (..)
import Model.Views exposing (ViewEvent(..))
import Ports.Photo
import Ports.Storage
import Update.Utils exposing (doNavClose, doSaveModel)


update : Model -> ViewEvent -> ( Model, Cmd Msg )
update model currentView =
    let
        changedView =
            { model | view = currentView }
    in
    case currentView of
        ViewDashboard ->
            ( { changedView
                | tmpVehicle = Nothing
                , tmpWeapon = Nothing
                , tmpUpgrade = Nothing
              }
            , Cmd.batch
                [ doSaveModel
                , doNavClose
                ]
            )

        ViewDetails v ->
            ( changedView
            , Cmd.batch
                [ Ports.Photo.destroyStream ""
                , doSaveModel
                , doNavClose
                ]
            )

        ViewPrint v ->
            ( changedView
            , Cmd.none
            )

        ViewSettings ->
            ( changedView
            , Cmd.batch
                [ Ports.Storage.getStorage ""
                , doNavClose
                ]
            )

        ViewSponsor ->
            ( changedView
            , doNavClose
            )

        ViewPrintAll ->
            ( changedView
            , Cmd.none
            )

        ViewNew _ ->
            ( changedView
            , Cmd.none
            )
