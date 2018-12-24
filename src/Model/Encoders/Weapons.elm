module Model.Encoders.Weapons exposing (weaponEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Weapons exposing (..)


weaponEncoder : Weapon -> List ( String, Value )
weaponEncoder w =
    [ ( "name", string w.name )
    , ( "wtype", string <| fromWeaponType w.wtype )
    , ( "mountPoint", string <| mountPointEncoder w.mountPoint )
    , ( "attack", diceEncoder w.attack )
    , ( "range", string <| fromWeaponRange w.range )
    , ( "slots", int w.slots )
    , ( "specials", list object <| List.map specialEncoder w.specials )
    , ( "cost", int w.cost )
    , ( "id", int w.id )
    , ( "status", weaponStatusEncoder w.status )
    , ( "ammoUsed", int w.ammoUsed )
    , ( "requiredSponsor", requiredSponsorEncoder w.requiredSponsor )
    ]


mountPointEncoder : Maybe WeaponMounting -> String
mountPointEncoder maybePoint =
    case maybePoint of
        Nothing ->
            ""

        Just point ->
            fromWeaponMounting point


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
