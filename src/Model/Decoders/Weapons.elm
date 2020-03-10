module Model.Decoders.Weapons exposing
    ( diceDecoder
    , mountPointDecoder
    , mountPointDecoderHelper
    , rangeDecoder
    , rangeHelper
    , weaponDecoder
    )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model.Decoders.Shared exposing (..)
import Model.Shared exposing (Size(..))
import Model.Weapon exposing (..)
import Model.Weapon.Common exposing (..)


weaponDecoder : Decoder Weapon
weaponDecoder =
    succeed Weapon
        |> required "name" string
        |> optional "mountPoint" (map Just mountPointDecoder) Nothing
        |> optional "attack" (map Just diceDecoder) Nothing
        |> hardcoded 0
        |> required "range" rangeDecoder
        |> required "slots" int
        |> required "specials" (list specialDecoder)
        |> required "cost" int
        |> hardcoded WeaponReady
        |> optional "requiredSponsor" (string |> andThen requiredSponsorDecoderHelper) Nothing
        |> required "category" (string |> andThen categoryDecoderHelper)


mountPointDecoder : Decoder WeaponMounting
mountPointDecoder =
    string
        |> andThen mountPointDecoderHelper


mountPointDecoderHelper : String -> Decoder WeaponMounting
mountPointDecoderHelper mountPointString =
    case mountPointString of
        "360° mounted" ->
            succeed Full

        "Front mounted" ->
            succeed Front

        "Left mounted" ->
            succeed LeftSide

        "Right mounted" ->
            succeed RightSide

        "Rear mounted" ->
            succeed Rear

        "Crew fired" ->
            succeed CrewFired

        _ ->
            fail <| mountPointString ++ " is not a valid mount point type"


diceDecoder : Decoder Dice
diceDecoder =
    succeed Dice
        |> required "number" int
        |> required "die" int


rangeDecoder : Decoder Range
rangeDecoder =
    string
        |> andThen rangeHelper


rangeHelper : String -> Decoder Range
rangeHelper str =
    case str of
        "Short" ->
            succeed Short

        "Medium" ->
            succeed Medium

        "Double" ->
            succeed Double

        "Large" ->
            succeed TemplateLarge

        "Large Burst" ->
            succeed <| BurstRange Large

        "Small Burst" ->
            succeed <| BurstRange Small

        "Smash" ->
            succeed SmashRange

        _ ->
            fail <| str ++ " is not a valid range type"
