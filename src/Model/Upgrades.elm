module Model.Upgrades exposing (Upgrade, allUpgradesList, armourPlating, extraCrewmember, nameToUpgrade, nitroBooster, tankTracks, turretMounting, upgradeDecoder)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Model.Weapons exposing (..)


type alias Upgrade =
    { name : String
    , slots : Int
    , specials : List Special
    , cost : Int
    , id : Int
    }


upgradeDecoder : Decoder Upgrade
upgradeDecoder =
    decode Upgrade
        |> required "name" D.string
        |> required "slots" D.int
        --|> required "specials" (D.list specialDecoder)
        |> hardcoded []
        |> required "cost" D.int
        |> required "id" D.int


allUpgradesList : List Upgrade
allUpgradesList =
    [ turretMounting
    , nitroBooster
    , armourPlating
    , tankTracks
    , extraCrewmember
    ]


nameToUpgrade : String -> Maybe Upgrade
nameToUpgrade name =
    case name of
        "Turret Mounting For Weapons" ->
            Just turretMounting

        "Nitro Booster" ->
            Just nitroBooster

        "Armour Plating" ->
            Just armourPlating

        "Tank Tracks" ->
            Just tankTracks

        "Extra Crewmember" ->
            Just extraCrewmember

        _ ->
            Nothing


turretMounting : Upgrade
turretMounting =
    Upgrade "Turret Mounting For Weapons" 0 [ SpecialRule "Weapon gains 360 arc of fire." ] 3 -1


nitroBooster : Upgrade
nitroBooster =
    Upgrade "Nitro Booster" 0 [ Ammo 1, SpecialRule "TBD" ] 6 -1


armourPlating : Upgrade
armourPlating =
    Upgrade "Armour Plating" 1 [ HullMod 2 ] 4 -1


tankTracks : Upgrade
tankTracks =
    Upgrade "Tank Tracks" 1 [ GearMod -1, HandlingMod 1, SpecialRule "TBD" ] 4 -1


extraCrewmember : Upgrade
extraCrewmember =
    Upgrade "Extra Crewmember" 0 [ CrewMod 1 ] 4 -1
