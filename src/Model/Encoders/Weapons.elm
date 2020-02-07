module Model.Encoders.Weapons exposing (weaponEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)


weaponEncoder : Weapon -> List ( String, Value )
weaponEncoder w =
    [ ( "name", string w.name )
    , ( "mountPoint", mountPointEncoder w.mountPoint )
    , ( "attack", diceEncoder w.attack )
    , ( "range", string <| fromWeaponRange w.range )
    , ( "slots", int w.slots )
    , ( "specials", list object <| List.map specialEncoder w.specials )
    , ( "cost", int w.cost )
    , ( "status", weaponStatusEncoder w.status )
    , ( "requiredSponsor", requiredSponsorEncoder w.requiredSponsor )
    , ( "category", categoryEncoder w.category )
    ]


mountPointEncoder : Maybe WeaponMounting -> Value
mountPointEncoder maybePoint =
    case maybePoint of
        Nothing ->
            null

        Just point ->
            string <| fromWeaponMounting point


diceEncoder : Maybe Dice -> Value
diceEncoder maybeDice =
    case maybeDice of
        Nothing ->
            null

        Just dice ->
            object [ ( "number", int dice.number ), ( "die", int dice.die ) ]


weaponStatusEncoder : WeaponStatus -> Value
weaponStatusEncoder ws =
    string <| fromWeaponStatus ws
