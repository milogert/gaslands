module Model.Encoders.Upgrades exposing (upgradeEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (expansionEncoder, specialEncoder)
import Model.Upgrade.Model exposing (Upgrade)


upgradeEncoder : Upgrade -> List ( String, Value )
upgradeEncoder u =
    [ ( "name", string u.name )
    , ( "slots", int u.slots )
    , ( "specials", list object <| List.map specialEncoder u.specials )
    , ( "cost", int u.cost )
    , ( "expansion", object <| expansionEncoder u.expansion )
    ]
