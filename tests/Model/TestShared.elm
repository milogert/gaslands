module Model.TestShared exposing (expansionSuite, specialSuite)

import Expect exposing (Expectation)
import Model.Shared exposing (..)
import Model.Upgrade.Common
import Model.Vehicle.Model exposing (defaultVehicle)
import Model.Weapon.BaseGame
import Test exposing (..)


specialSuite : Test
specialSuite =
    describe "tests for special-related functions" <|
        [ test "ammo init" <|
            \_ ->
                Expect.equal
                    (Ammo [ False, False, False ])
                    (ammoInit 3)
        , test "finding ammo in an special list" <|
            \_ ->
                let
                    specials =
                        [ SpecialRule "test"
                        , Ammo [ False ]
                        , Blast
                        , Fire
                        ]
                in
                Expect.equal
                    ( Just 1, Just <| Ammo [ False ] )
                    (getAmmoClip specials)
        , test "find nothing with no ammo" <|
            \_ ->
                Expect.equal
                    ( Nothing, Nothing )
                    (getAmmoClip [ Blast, Fire ])
        ]
            ++ specialToStringItemsTests


specialToStringItemsTests : List Test
specialToStringItemsTests =
    specialToStringItems
        |> List.map
            (\( sp, st ) ->
                test ("special to string: " ++ st) <|
                    \_ ->
                        Expect.equal
                            st
                            (fromSpecial sp)
            )


specialToStringItems : List ( Special, String )
specialToStringItems =
    [ ( Ammo [ False ], "Ammo 1" )
    , ( SpecialRule "dummy", "SpecialRule dummy" )
    , ( NamedSpecialRule "name" "desc", "NamedSpecialRule name desc" )
    , ( TreacherousSurface, "TreacherousSurface" )
    , ( Blast, "Blast" )
    , ( Fire, "Fire" )
    , ( Explosive, "Explosive" )
    , ( Blitz, "Blitz" )
    , ( HighlyExplosive, "HighlyExplosive" )
    , ( Electrical, "Electrical" )
    , ( HandlingMod 10, "HandlingMod 10" )
    , ( HullMod 5, "HullMod 5" )
    , ( GearMod 8, "GearMod 8" )
    , ( CrewMod 0, "CrewMod 0" )
    , ( Specialist, "Specialist" )
    , ( Entangle, "Entangle" )
    ]


expansionSuite : Test
expansionSuite =
    describe "tests for expansions"
        [ test "expansion types to names, full" <|
            \_ ->
                Expect.equal
                    [ "Base Game", "Time Extended 10" ]
                    (List.map fromExpansion [ BaseGame, TX 10 ])
        , test "expansion types to names, abbreviation" <|
            \_ ->
                Expect.equal
                    [ "BG", "TX#10" ]
                    (List.map fromExpansionAbbrev [ BaseGame, TX 10 ])
        , test "check expansion filter is operating" <|
            \_ ->
                let
                    actual =
                        Model.Weapon.BaseGame.weapons
                            |> List.map (expansionFilter [ TX 2 ])

                    expected =
                        List.repeat (List.length Model.Weapon.BaseGame.weapons) False
                in
                Expect.equal
                    expected
                    actual
        ]
