module Model.Decoders.Weapons exposing
    ( diceDecoder
    , mountPointDecoder
    , mountPointDecoderHelper
    , rangeDecoder
    , rangeHelper
    , weaponDecoder
    , wtypeDecoder
    )

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model.Decoders.Shared exposing (..)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)


weaponDecoder : Decoder Weapon
weaponDecoder =
    succeed Weapon
        |> required "name" string
        |> required "wtype" wtypeDecoder
        |> optional "mountPoint" (map Just mountPointDecoder) Nothing
        |> optional "attack" (map Just diceDecoder) Nothing
        |> hardcoded 0
        |> required "range" rangeDecoder
        |> required "slots" int
        |> required "specials" (list specialDecoder)
        |> required "cost" int
        |> hardcoded WeaponReady
        |> optional "requiredSponsor" (string |> andThen requiredSponsorDecoderHelper) Nothing
        |> required "expansion" expansionDecoder


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


wtypeDecoder : Decoder WeaponType
wtypeDecoder =
    string
        |> andThen
            (\str ->
                case str of
                    "Shooting" ->
                        succeed Shooting

                    "Dropped" ->
                        succeed Dropped

                    "SmashType" ->
                        succeed SmashType

                    _ ->
                        fail <| str ++ " is not a valid weapon type"
            )


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
            succeed BurstLarge

        "Small Burst" ->
            succeed BurstSmall

        "Smash" ->
            succeed SmashRange

        _ ->
            fail <| str ++ " is not a valid range type"
