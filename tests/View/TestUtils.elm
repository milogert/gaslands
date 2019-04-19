module View.TestUtils exposing (suite)

import Expect exposing (Expectation)
import Html
    exposing
        ( div
        , text
        )
import Model.Shared exposing (..)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import View.Utils exposing (..)


suite : Test
suite =
    describe "View Utilities Tests" <|
        []
            ++ iconTests
            ++ detailsTest
            ++ specialTests


iconTests : List Test
iconTests =
    (test "iconClass" <|
        \_ ->
            [ iconClass "fas" "test" [ "extra" ] ]
                |> div []
                |> Query.fromHtml
                |> Query.find [ Selector.tag "i" ]
                |> Query.has
                    (List.map Selector.class [ "fas", "fa-test", "extra" ])
    )
        :: ([ ( "icon", icon, [ "fas", "fa-test" ] )
            , ( "iconb", iconb, [ "fab", "fa-test" ] )
            ]
                |> List.map
                    (\( name, func, classes ) ->
                        test name <|
                            \_ ->
                                [ func "test" ]
                                    |> div []
                                    |> Query.fromHtml
                                    |> Query.find [ Selector.tag "i" ]
                                    |> Query.has
                                        (List.map Selector.class classes)
                    )
           )


detailsTest : List Test
detailsTest =
    [ test "detail section" <|
        \_ ->
            detailSection [ text "cool" ] [ text "header" ]
                |> Query.fromHtml
                |> Query.has
                    [ Selector.tag "hr"
                    , Selector.tag "h5"
                    , Selector.tag "div"
                    , Selector.text "cool"
                    , Selector.text "header"
                    ]
    ]


specialTests : List Test
specialTests =
    [ ( "ammo, no event", Ammo [ True ], [ Selector.text "" ] )
    , ( "high explosive", HighlyExplosive, [ Selector.text "Highly Explosive" ] )
    , ( "TreacherousSurface", TreacherousSurface, [ Selector.text "The dropped template counts as a treacherous surface." ] )
    , ( "special rule", SpecialRule "test rule", [ Selector.text "test rule" ] )
    , ( "named special rule"
      , NamedSpecialRule "name" "desc"
      , [ Selector.tag "span"
        , Selector.tag "b"
        , Selector.text "name: "
        , Selector.text "desc"
        ]
      )
    , ( "mod: handling", HandlingMod 1, [ Selector.text "Handling modification: 1" ] )
    , ( "mod: hull", HullMod 1, [ Selector.text "Hull modification: 1" ] )
    , ( "mod: gear", GearMod 1, [ Selector.text "Gear modification: 1" ] )
    , ( "mod: crew", CrewMod 1, [ Selector.text "Crew modification: 1" ] )
    , ( "blast", Blast, [ Selector.text "Blast" ] )
    , ( "fire", Fire, [ Selector.text "Fire" ] )
    , ( "explosive", Explosive, [ Selector.text "Explosive" ] )
    , ( "blitz", Blitz, [ Selector.text "Blitz" ] )
    , ( "electrical", Electrical, [ Selector.text "Electrical" ] )
    , ( "specialist", Specialist, [ Selector.text "Specialist" ] )
    , ( "entangle", Entangle, [ Selector.text "Entangle" ] )
    ]
        |> List.map
            (\( name, special, selectors ) ->
                test name <|
                    \_ ->
                        [ renderSpecial True True Nothing Nothing special ]
                            |> div []
                            |> Query.fromHtml
                            |> Query.has selectors
            )
