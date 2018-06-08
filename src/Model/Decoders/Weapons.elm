module Model.Decoders.Weapons exposing (..)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Weapons exposing (..)


weaponDecoder : Decoder Weapon
weaponDecoder =
    decode Weapon
        |> required "name" D.string
        |> required "wtype" wtypeDecoder
        |> required "attack" diceDecoder
        |> required "range" rangeDecoder
        |> required "slots" D.int
        |> required "specials" (D.list specialDecoder)
        |> required "cost" D.int
        |> required "id" D.int


specialDecoder : Decoder Special
specialDecoder =
    D.field "type" D.string
        |> D.andThen (\str ->
            case str of
                "Ammo" -> ammoDecoder
                "SpecialRule" -> specialRuleDecoder
                "Blast" -> blastDecoder
                "Fire" -> fireDecoder
                "Explosive" -> explosiveDecoder
                "Blitz" -> blitzDecoder
                "CrewFired" -> crewFiredDecoder
                "HighlyExplosive" -> highlyExplosiveDecoder
                "Electrical" -> electricalDecoder
                "HandlingMod" -> handlingModDecoder
                "HullMod" -> hullModDecoder
                "GearMod" -> gearModDecoder
                "CrewMod" -> crewModDecoder
                _ -> D.fail <| str ++ " is not a valid special type"
        )


ammoDecoder : Decoder Special
ammoDecoder =
    D.map Ammo (D.field "count" D.int)


specialRuleDecoder : Decoder Special
specialRuleDecoder =
    D.map SpecialRule (D.field "text" D.string)


blastDecoder : Decoder Special
blastDecoder =
    D.succeed Blast


fireDecoder : Decoder Special
fireDecoder =
    D.succeed Fire


explosiveDecoder : Decoder Special
explosiveDecoder =
    D.succeed Explosive


blitzDecoder : Decoder Special
blitzDecoder =
    D.succeed Blitz


crewFiredDecoder : Decoder Special
crewFiredDecoder =
    D.succeed CrewFired


highlyExplosiveDecoder : Decoder Special
highlyExplosiveDecoder =
    D.succeed HighlyExplosive


electricalDecoder : Decoder Special
electricalDecoder =
    D.succeed Electrical


handlingModDecoder : Decoder Special
handlingModDecoder =
    D.map HandlingMod (D.field "modifier" D.int)


hullModDecoder : Decoder Special
hullModDecoder =
    D.map HullMod (D.field "modifier" D.int)


gearModDecoder : Decoder Special
gearModDecoder =
    D.map GearMod (D.field "modifier" D.int)


crewModDecoder : Decoder Special
crewModDecoder =
    D.map CrewMod (D.field "modifier" D.int)


wtypeDecoder : Decoder WeaponType
wtypeDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Shooting" -> D.succeed Shooting
                "Dropped" -> D.succeed Dropped
                "SmashType" -> D.succeed SmashType
                _ -> D.fail <| str ++ " is not a valid weapon type"
        )


rangeDecoder : Decoder Range
rangeDecoder =
    D.string
        |> D.andThen (\str ->
            case str of
                "Medium" -> D.succeed Medium
                "Double" -> D.succeed Double
                "TemplateLarge" -> D.succeed TemplateLarge
                "BurstLarge" -> D.succeed BurstLarge
                "BurstSmall" -> D.succeed BurstSmall
                "SmashRange" -> D.succeed SmashRange
                _ -> D.fail <| str ++ " is not a valid range type"
        )


diceDecoder : Decoder Dice
diceDecoder =
    decode Dice
        |> required "number" D.int
        |> required "die" D.int
