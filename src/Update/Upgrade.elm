module Update.Upgrade exposing (update)

import Dict exposing (Dict)
import List.Extra
import Model.Model exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Upgrade.Model exposing (..)
import Model.Vehicle.Common exposing (..)
import Update.Utils exposing (doCloseModal, doSaveModel)


update : Model -> UpgradeEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        AddUpgrade v u ->
            addUpgrade model v u

        DeleteUpgrade v u ->
            deleteUpgrade model v u

        TmpUpgradeUpdate name ->
            let
                u =
                    nameToUpgrade name
            in
            ( { model | tmpUpgrade = u }
            , Cmd.none
            )


addUpgrade : Model -> String -> Upgrade -> ( Model, Cmd Msg )
addUpgrade model key u =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                upgradeList =
                    vehicle.upgrades ++ [ u ]

                nv =
                    { vehicle | upgrades = upgradeList }
            in
            ( { model
                | view = ViewDetails nv
                , error = []
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.batch [ doSaveModel, doCloseModal "upgrade" ]
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
                        |> List.Extra.remove u

                nv =
                    { vehicle | upgrades = upgradesNew }
            in
            ( { model
                | view = ViewDetails nv
                , vehicles = Dict.insert key nv model.vehicles
              }
            , doSaveModel
            )
