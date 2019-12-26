module Update.View exposing (update)

import Model.Model exposing (..)
import Model.Views exposing (ViewEvent(..))
import Ports.Photo
import Ports.Storage
import Update.Utils exposing (doSaveModel)


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
            , doSaveModel
            )

        ViewDetails v ->
            ( changedView
            , Cmd.batch
                [ Ports.Photo.destroyStream ""
                , doSaveModel
                ]
            )

        ViewPrint v ->
            ( changedView
            , Cmd.none
            )

        ViewSettings ->
            ( changedView
            , Ports.Storage.getStorage ""
            )

        _ ->
            ( { model | view = currentView }
            , Cmd.none
            )
