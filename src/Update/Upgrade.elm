module Update.Upgrade exposing (addUpgrade, deleteUpgrade)

import Dict exposing (Dict)
import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Update.Utils


addUpgrade : Model -> String -> Upgrade -> ( Model, Cmd Msg )
addUpgrade model key u =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                upgradeList =
                    vehicle.upgrades ++ [ { u | id = List.length vehicle.upgrades } ]

                nv =
                    { vehicle | upgrades = upgradeList }
            in
            ( { model
                | view = ViewDetails nv
                , error = []
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


deleteUpgrade : Model -> String -> Upgrade -> ( Model, Cmd Msg )
deleteUpgrade model key u =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                upgradesNew =
                    vehicle.upgrades
                        |> Update.Utils.deleteFromList u.id
                        |> Update.Utils.correctIds

                nv =
                    { vehicle | upgrades = upgradesNew }
            in
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )
