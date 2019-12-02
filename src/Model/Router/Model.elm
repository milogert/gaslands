module Model.Router.Model exposing (RouteEvent(..))

import Browser exposing (UrlRequest)
import Url exposing (Url)


type RouteEvent
    = RouteRequest UrlRequest
    | RouteChange Url
