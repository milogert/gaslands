module Model.Encoders.Settings exposing (settingsEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (expansionEncoder)
import Model.Settings exposing (..)


settingsEncoder : Settings -> List ( String, Value )
settingsEncoder settings =
    [ ( "percentVehicles", int settings.percentVehicles )
    , ( "percentWeapons", int settings.percentWeapons )
    , ( "percentUpgrades", int settings.percentUpgrades )
    , ( "percentPerks", int settings.percentPerks )
    , ( "pointsAllowed", int settings.pointsAllowed )
    , ( "spinResults", list object <| List.map spinResultEncoder settings.spinResults )
    , ( "expansions", object <| expansionTrackerEncoder settings.expansions )
    ]


spinResultEncoder : SpinResult -> List ( String, Value )
spinResultEncoder spinResults =
    [ ( "summary", string spinResults.summary )
    , ( "cost", int spinResults.cost )
    ]


expansionTrackerEncoder : ExpansionTracker -> List ( String, Value )
expansionTrackerEncoder { enabled, available } =
    [ ( "enabled"
      , list object <| List.map expansionEncoder enabled
      )
    , ( "available"
      , list object <| List.map expansionEncoder available
      )
    ]



-- list object <| List.map expansionEncoder settings.expansions
