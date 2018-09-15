module Model.Decoders.Weapons exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model.Weapons exposing (..)
import Model.Decoders.Shared exposing (..)


weaponDecoder : Decoder Weapon
weaponDecoder =
    decode Weapon
        |> required "name" string
        |> required "wtype" wtypeDecoder
        |> optional "mountPoint" (map Just mountPointDecoder) Nothing
        |> optional "attack" (map Just diceDecoder) Nothing
        |> hardcoded 0
        |> required "range" rangeDecoder
        |> required "slots" int
        |> required "specials" (list specialDecoder)
        |> required "cost" int
        |> required "id" int
        |> hardcoded WeaponReady
        |> hardcoded 0
        |> required "requiredSponsor" (string |> andThen requiredSponsorDecoderHelper)


mountPointDecoder : Decoder WeaponMounting
mountPointDecoder =
    string
        |> andThen mountPointDecoderHelper


mountPointDecoderHelper : String -> Decoder WeaponMounting
mountPointDecoderHelper mountPointString =
    case mountPointString of
        "Full" ->
            succeed <| Full

        "Front" ->
            succeed <| Front

        "LeftSide" ->
            succeed <| LeftSide

        "RightSide" ->
            succeed <| RightSide

        "Rear" ->
            succeed <| Rear

        "CrewFired" ->
            succeed <| CrewFired

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
    decode Dice
        |> required "number" int
        |> required "die" int


rangeDecoder : Decoder Range
rangeDecoder =
    string
        |> andThen rangeHelper


rangeHelper : String -> Decoder Range
rangeHelper str =
    case str of
        "Medium" ->
            succeed Medium

        "Double" ->
            succeed Double

        "TemplateLarge" ->
            succeed TemplateLarge

        "BurstLarge" ->
            succeed BurstLarge

        "BurstSmall" ->
            succeed BurstSmall

        "SmashRange" ->
            succeed SmashRange

        _ ->
            fail <| str ++ " is not a valid range type"
