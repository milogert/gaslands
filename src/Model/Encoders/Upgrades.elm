module Model.Encoders.Upgrades exposing (upgradeEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (requiredSponsorEncoder, specialEncoder)
import Model.Upgrade exposing (Upgrade)


upgradeEncoder : Upgrade -> List ( String, Value )
upgradeEncoder u =
    [ ( "name", string u.name )
    , ( "slots", int u.slots )
    , ( "specials", list object <| List.map specialEncoder u.specials )
    , ( "cost", int u.cost )
    , ( "requiredSponsor", requiredSponsorEncoder u.requiredSponsor )
    ]
