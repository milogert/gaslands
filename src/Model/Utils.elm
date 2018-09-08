module Model.Utils exposing (totalHandling, totalHull, totalGear, totalCrew)

import Model.Shared exposing (..)
import Model.Vehicles exposing (..)


modToInt : Special -> Int
modToInt s =
    case s of
        HandlingMod i ->
            i

        HullMod i ->
            i

        GearMod i ->
            i

        CrewMod i ->
            i

        _ ->
            0


totalHandling : Vehicle -> Int
totalHandling v =
    let
        mod =
            List.sum <|
                List.map modToInt <|
                    List.filter
                        (\m ->
                            case m of
                                HandlingMod _ ->
                                    True

                                _ ->
                                    False
                        )
                    <|
                        List.concat <|
                            List.map .specials v.upgrades
    in
        v.handling + mod


totalHull : Vehicle -> Int
totalHull v =
    let
        mod =
            List.sum <|
                List.map modToInt <|
                    List.filter
                        (\m ->
                            case m of
                                HullMod _ ->
                                    True

                                _ ->
                                    False
                        )
                    <|
                        List.concat <|
                            List.map .specials v.upgrades
    in
        v.hull.max + mod


totalGear : Vehicle -> Int
totalGear v =
    let
        mod =
            List.sum <|
                List.map modToInt <|
                    List.filter
                        (\m ->
                            case m of
                                GearMod _ ->
                                    True

                                _ ->
                                    False
                        )
                    <|
                        List.concat <|
                            List.map .specials v.upgrades
    in
        v.gear.max + mod |> clamp 1 6


totalCrew : Vehicle -> Int
totalCrew v =
    let
        mod =
            List.sum <|
                List.map modToInt <|
                    List.filter
                        (\m ->
                            case m of
                                CrewMod _ ->
                                    True

                                _ ->
                                    False
                        )
                    <|
                        List.concat <|
                            List.map .specials v.upgrades
    in
        v.crew + mod
