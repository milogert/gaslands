module Model.Routes exposing (..)

import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Route
    = RouteDashboard
    | RouteDetails String
    | RoutePrintAll
    | RoutePrint String
    | RouteSettings


routeMap : Parser (Route -> a) a
routeMap =
    oneOf
        [ map RouteDashboard top
        , map RouteDetails (s "details" </> string)
        , map RoutePrintAll (s "print")
        , map RoutePrint (s "print" </> string)
        , map RouteSettings (s "settings")
        ]
