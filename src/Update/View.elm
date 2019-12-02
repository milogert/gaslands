module Update.View exposing (update)

import Model.Model exposing (..)
import Model.Routes exposing (Route(..))
import Ports.Photo
import Ports.Storage
import Update.Utils exposing (doSaveModel)


update : Model -> Route -> ( Model, Cmd Msg )
update model currentView =
    case currentView of
        RouteDashboard ->
            ( { model
                | view = RouteDashboard
                , tmpVehicle = Nothing
                , tmpWeapon = Nothing
                , tmpUpgrade = Nothing
              }
            , doSaveModel
            )

        RouteDetails v ->
            ( { model | view = RouteDetails v }
            , Cmd.batch
                [ Ports.Photo.destroyStream ""
                , doSaveModel
                ]
            )

        RoutePrint v ->
            ( { model | view = RoutePrint v }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
