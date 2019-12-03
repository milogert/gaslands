module Update.Routes exposing (urlChanged, urlRequested)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Model.Model exposing (..)
import Model.Routes exposing (Route(..), routeMap)
import Ports.Storage
import Update.Utils exposing (doOtherMsg)
import Url exposing (Url)
import Url.Parser


urlRequested : Model -> UrlRequest -> ( Model, Cmd Msg )
urlRequested model request =
    let
        cmdBatch =
            \url route ->
                Cmd.batch <|
                    Nav.pushUrl model.key (Url.toString url)
                        :: doPreloadWork model RouteDashboard
    in
    case request of
        Browser.Internal url ->
            case Url.Parser.parse routeMap url of
                Nothing ->
                    ( model, cmdBatch url RouteDashboard )

                Just route ->
                    ( model, cmdBatch url route )

        Browser.External href ->
            ( model, Nav.load href )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    case Url.Parser.parse routeMap url of
        Nothing ->
            ( { model
                | view = RouteDashboard
                , url = url
              }
            , Cmd.none
            )

        Just route ->
            ( { model
                | view = route
                , url = url
              }
            , Cmd.none
            )


doPreloadWork : Model -> Route -> List (Cmd Msg)
doPreloadWork model request =
    [ ( RouteSettings, Ports.Storage.getKeys <| Maybe.withDefault "" model.teamName ) ]
        |> List.filterMap (possibleCmd request)


possibleCmd : Route -> ( Route, Cmd Msg ) -> Maybe (Cmd Msg)
possibleCmd filter tuple =
    let
        ( route, cmd ) =
            tuple
    in
    case route == filter of
        True ->
            Just cmd

        False ->
            Nothing