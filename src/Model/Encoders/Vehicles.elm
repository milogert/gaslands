module Model.Encoders.Vehicles exposing (vehicleEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Encoders.Sponsors exposing (vehiclePerkEncoder)
import Model.Encoders.Upgrades exposing (upgradeEncoder)
import Model.Encoders.Weapons exposing (weaponEncoder)
import Model.Vehicles exposing (..)


vehicleEncoder : Vehicle -> Value
vehicleEncoder v =
    object
        [ ( "name", string v.name )
        , ( "photo", string <| photoEncoder v.photo )
        , ( "vtype", string <| fromVehicleType v.vtype )
        , ( "gear", object <| gearEncoder v.gear )
        , ( "handling", int v.handling )
        , ( "hull", object <| hullEncoder v.hull )
        , ( "crew", int v.crew )
        , ( "equipment", int v.equipment )
        , ( "weight", string <| fromVehicleWeight v.weight )
        , ( "activated", bool v.activated )
        , ( "weapons", list object <| List.map weaponEncoder v.weapons )
        , ( "upgrades", list object <| List.map upgradeEncoder v.upgrades )
        , ( "notes", string v.notes )
        , ( "cost", int v.cost )
        , ( "key", string v.key )
        , ( "specials", list object <| List.map specialEncoder v.specials )
        , ( "perks", list object <| List.map vehiclePerkEncoder v.perks )
        , ( "requiredSponsor", requiredSponsorEncoder v.requiredSponsor )
        ]


photoEncoder : Maybe String -> String
photoEncoder ms =
    Maybe.withDefault "" ms


gearEncoder : GearTracker -> List ( String, Value )
gearEncoder gear =
    [ ( "current", int gear.current ), ( "max", int gear.max ) ]


hullEncoder : HullHolder -> List ( String, Value )
hullEncoder hull =
    [ ( "current", int hull.current ), ( "max", int hull.max ) ]
