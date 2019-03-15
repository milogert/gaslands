module Model.TestEncodeDecode exposing (suite)

import Expect exposing (Expectation)
import Json.Decode as JsonD
import Json.Encode as JsonE
import Model.Decoders.Shared exposing (..)
import Model.Decoders.Weapons exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Shared exposing (..)
import Model.Upgrade.Common
import Model.Vehicle.Model exposing (defaultVehicle)
import Model.Weapon.Common exposing (..)
import Model.Weapon.Model exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "thing -> encode -> decode -> thing" <|
        []
            ++ specialSuite
            ++ rangeSuite
            ++ mountSuite


specialSuite : List Test
specialSuite =
    [ Ammo [ True, False, True ]
    , SpecialRule "Special Rule"
    , NamedSpecialRule "Special Rule" "Description."
    , TreacherousSurface
    , Blast
    , Fire
    , Explosive
    , Blitz
    , HighlyExplosive
    , Electrical
    , HandlingMod 0
    , HullMod 1
    , GearMod 10
    , CrewMod -100
    , Specialist
    , Entangle
    ]
        |> List.map testSpecial


testSpecial : Special -> Test
testSpecial special =
    test ("special test: " ++ fromSpecial special) <|
        \_ ->
            special
                |> specialEncoder
                |> JsonE.object
                |> JsonD.decodeValue specialDecoder
                |> Expect.equal (Ok special)


rangeSuite : List Test
rangeSuite =
    [ Short
    , Medium
    , Double
    , TemplateLarge
    , BurstLarge
    , BurstSmall
    , SmashRange

    -- , SpecialRange "testing"
    ]
        |> List.map testRange


testRange : Range -> Test
testRange range =
    test ("range test: " ++ fromWeaponRange range) <|
        \_ ->
            range
                |> fromWeaponRange
                |> JsonE.string
                |> JsonD.decodeValue rangeDecoder
                |> Expect.equal (Ok range)


mountSuite : List Test
mountSuite =
    [ Full
    , Front
    , LeftSide
    , RightSide
    , Rear
    , CrewFired
    ]
        |> List.map testMount


testMount : WeaponMounting -> Test
testMount mount =
    test ("mount test: " ++ fromWeaponMounting mount) <|
        \_ ->
            mount
                |> fromWeaponMounting
                |> JsonE.string
                |> JsonD.decodeValue mountPointDecoder
                |> Expect.equal (Ok mount)
