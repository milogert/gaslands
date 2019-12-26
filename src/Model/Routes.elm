module Model.Routes exposing (NewType(..), Route(..), routeMap)

import Url.Parser exposing ((</>), Parser, fragment, int, map, oneOf, s, string, top)


type Route
    = RouteDashboard
    | RouteNew NewType
    | RouteDetails String
    | RouteSponsor
    | RoutePrintAll
    | RoutePrint String
    | RouteSettings


type NewType
    = NewVehicle
    | NewWeapon String
    | NewUpgrade String


routeMap : Parser (Route -> a) a
routeMap =
    oneOf
        [ map RouteDashboard top
        , map RouteNew
            (s "new"
                </> oneOf
                        [ map NewVehicle (s "vehicle")
                        , map NewWeapon (s "weapon" </> string)
                        , map NewUpgrade (s "upgrade" </> string)
                        ]
            )
        , map RouteDetails (s "details" </> string)
        , map RouteSponsor (s "sponsor")
        , map RoutePrintAll (s "print")
        , map RoutePrint (s "print" </> string)
        , map RouteSettings (s "settings")
        ]
