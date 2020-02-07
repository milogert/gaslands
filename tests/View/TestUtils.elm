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
            detailSection "cool" [] [ text "header" ]
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
    [ ( "ammo, no event", Ammo [ True ], [ Selector.tag "div", Selector.tag "div" ] )
    , ( "special rule", SpecialRule "test rule", [ Selector.text "test rule" ] )
    , ( "named special rule"
      , NamedSpecialRule "name" "desc"
      , [ Selector.text "name"
        , Selector.text "desc"
        ]
      )
    , ( "mod: handling", HandlingMod 1, [ Selector.text "Handling Mod", Selector.text "1" ] )
    , ( "mod: hull", HullMod 1, [ Selector.text "Hull Mod", Selector.text "1" ] )
    , ( "mod: gear", GearMod 1, [ Selector.text "Gear Mod", Selector.text "1" ] )
    , ( "mod: crew", CrewMod 1, [ Selector.text "Crew Mod", Selector.text "1" ] )
    , ( "blast", Blast, [ Selector.text "Blast" ] )
    , ( "fire", Fire, [ Selector.text "Fire" ] )
    , ( "blitz", Blitz, [ Selector.text "Blitz" ] )
    , ( "electrical", Electrical, [ Selector.text "Electrical" ] )
    ]
        |> List.map
            (\( name, special, selectors ) ->
                test name <|
                    \_ ->
                        special
                            |> specialToHeaderBody True True Nothing Nothing
                            |> View.Utils.renderSpecialRow
                            |> (\r ->
                                    div [] [ r ]
                                        |> Query.fromHtml
                                        |> Query.has selectors
                               )
            )
