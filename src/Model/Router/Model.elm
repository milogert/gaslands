module Model.Router.Model exposing (..)

import Browser exposing (UrlRequest)
import Url exposing (Url)


type RouteEvent
    = RouteRequest UrlRequest
    | RouteChange Url
