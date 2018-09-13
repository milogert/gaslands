module Model.Encoders.Weapons exposing (weaponEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Weapons exposing (..)


weaponEncoder : Weapon -> Value
weaponEncoder w =
    object
        [ ( "name", string w.name )
        , ( "wtype", string <| toString w.wtype )
        , ( "mountPoint", mountPointEncoder w.mountPoint )
        , ( "attack", diceEncoder w.attack )
        , ( "range", string <| toString w.range )
        , ( "slots", int w.slots )
        , ( "specials", list <| List.map specialEncoder w.specials )
        , ( "cost", int w.cost )
        , ( "id", int w.id )
        , ( "status", weaponStatusEncoder w.status )
        , ( "ammoUsed", int w.ammoUsed )
        ]


mountPointEncoder : Maybe WeaponMounting -> Value
mountPointEncoder maybePoint =
    case maybePoint of
        Just point ->
            string <| toString point

        Nothing ->
            null


diceEncoder : Maybe Dice -> Value
diceEncoder maybeDice =
    case maybeDice of
        Nothing ->
            null

        Just dice ->
            object [ ( "number", int dice.number ), ( "die", int dice.die ) ]


weaponStatusEncoder : WeaponStatus -> Value
weaponStatusEncoder ws =
    string <| toString ws
