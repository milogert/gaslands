module Model.Encoders.Upgrades exposing (upgradeEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (specialEncoder)
import Model.Upgrades exposing (Upgrade)


upgradeEncoder : Upgrade -> List ( String, Value )
upgradeEncoder u =
    [ ( "name", string u.name )
    , ( "slots", int u.slots )
    , ( "specials", list object <| List.map specialEncoder u.specials )
    , ( "cost", int u.cost )
    , ( "id", int u.id )
    ]
