module Model.Encoders.Vehicles exposing (vehicleEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Upgrades exposing (upgradeEncoder)
import Model.Encoders.Weapons exposing (weaponEncoder)
import Model.Vehicles exposing (..)


vehicleEncoder : Vehicle -> Value
vehicleEncoder v =
    object 
        [ ("name", string v.name)
        , ("vtype", string <| vTToStr v.vtype)
        , ("gear", gearEncoder v.gear)
        , ("handling", int v.handling)
        , ("hull", hullEncoder v.hull)
        , ("crew", int v.crew)
        , ("equipment", int v.equipment)
        , ("weight", string <| toString v.weight)
        , ("activated", bool v.activated)
        , ("weapons", list <| List.map weaponEncoder v.weapons)
        , ("upgrades", list <| List.map upgradeEncoder v.upgrades)
        , ("notes", string v.notes)
        , ("cost", int v.cost)
        , ("id", int v.id)
        ]


gearEncoder : GearTracker -> Value
gearEncoder gear =
    object [ ("current", int gear.current), ("max", int gear.max) ]


hullEncoder : HullHolder -> Value
hullEncoder hull =
    object [ ("current", int hull.current), ("max", int hull.max) ]
