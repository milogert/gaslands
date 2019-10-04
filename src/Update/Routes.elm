module Update.Routes exposing (urlChanged, urlRequested)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Model.Model exposing (..)
import Model.Routes exposing (Route(..), routeMap)
import Url exposing (Url)
import Url.Parser


urlRequested : Model -> UrlRequest -> ( Model, Cmd Msg )
urlRequested model request =
    case request of
        Browser.Internal url ->
            case Url.Parser.parse routeMap url of
                Nothing ->
                    ( { model | view = RouteDashboard }
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Just route ->
                    ( { model | view = route }
                    , Nav.pushUrl model.key (Url.toString url)
                    )

        Browser.External href ->
            ( model, Nav.load href )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    ( { model | url = url }, Cmd.none )
