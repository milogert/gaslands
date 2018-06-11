module Model.Decoders.Weapons exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Model.Weapons exposing (..)


weaponDecoder : Decoder Weapon
weaponDecoder =
    decode Weapon
        |> required "name" string
        |> required "wtype" wtypeDecoder
        |> optional "mountPoint" (oneOf [ mountPointDecoder, null Nothing ]) Nothing
        |> required "attack" diceDecoder
        |> hardcoded []
        |> required "range" rangeDecoder
        |> required "slots" int
        |> required "specials" (list specialDecoder)
        |> required "cost" int
        |> required "id" int
        |> hardcoded WeaponReady
        |> hardcoded 0


mountPointDecoder : Decoder (Maybe WeaponMounting)
mountPointDecoder =
    string
        |> andThen (\str ->
            case str of
                "Full" -> succeed <| Just Full
                "Front" -> succeed <| Just Front
                "LeftSide" -> succeed <| Just LeftSide
                "RightSide" -> succeed <| Just RightSide
                "Rear" -> succeed <| Just Rear
                "CrewFired" -> succeed <| Just CrewFired
                _ -> fail <| str ++ " is not a valid mount point type"
        )


specialDecoder : Decoder Special
specialDecoder =
    field "type" string
        |> andThen (\str ->
            case str of
                "Ammo" -> ammoDecoder
                "SpecialRule" -> specialRuleDecoder
                "TrecherousSurface" -> succeed TreacherousSurface
                "Blast" -> blastDecoder
                "Fire" -> fireDecoder
                "Explosive" -> explosiveDecoder
                "Blitz" -> blitzDecoder
                "HighlyExplosive" -> highlyExplosiveDecoder
                "Electrical" -> electricalDecoder
                "HandlingMod" -> handlingModDecoder
                "HullMod" -> hullModDecoder
                "GearMod" -> gearModDecoder
                "CrewMod" -> crewModDecoder
                _ -> fail <| str ++ " is not a valid special type"
        )


ammoDecoder : Decoder Special
ammoDecoder =
    map Ammo (field "count" int)


specialRuleDecoder : Decoder Special
specialRuleDecoder =
    map SpecialRule (field "text" string)


blastDecoder : Decoder Special
blastDecoder =
    succeed Blast


fireDecoder : Decoder Special
fireDecoder =
    succeed Fire


explosiveDecoder : Decoder Special
explosiveDecoder =
    succeed Explosive


blitzDecoder : Decoder Special
blitzDecoder =
    succeed Blitz


highlyExplosiveDecoder : Decoder Special
highlyExplosiveDecoder =
    succeed HighlyExplosive


electricalDecoder : Decoder Special
electricalDecoder =
    succeed Electrical


handlingModDecoder : Decoder Special
handlingModDecoder =
    map HandlingMod (field "modifier" int)


hullModDecoder : Decoder Special
hullModDecoder =
    map HullMod (field "modifier" int)


gearModDecoder : Decoder Special
gearModDecoder =
    map GearMod (field "modifier" int)


crewModDecoder : Decoder Special
crewModDecoder =
    map CrewMod (field "modifier" int)


wtypeDecoder : Decoder WeaponType
wtypeDecoder =
    string
        |> andThen (\str ->
            case str of
                "Shooting" -> succeed Shooting
                "Dropped" -> succeed Dropped
                "SmashType" -> succeed SmashType
                _ -> fail <| str ++ " is not a valid weapon type"
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
        "Medium" -> succeed Medium
        "Double" -> succeed Double
        "TemplateLarge" -> succeed TemplateLarge
        "BurstLarge" -> succeed BurstLarge
        "BurstSmall" -> succeed BurstSmall
        "SmashRange" -> succeed SmashRange
        _ -> fail <| str ++ " is not a valid range type"
