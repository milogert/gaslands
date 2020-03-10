module Update.Upgrade exposing (update)

import Dict
import List.Extra
import Model.Model exposing (..)
import Model.Upgrade exposing (..)
import Model.Upgrade.Common exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Views exposing (ViewEvent(..))
import Update.Utils exposing (goTo, goToTab)


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
                | error = []
                , vehicles = Dict.insert key nv model.vehicles
                , tmpUpgrade = Nothing
              }
            , Cmd.batch
                [ goToTab <| ViewDetails key
                , goTo ViewDashboard
                ]
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
                | vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.batch
                [ goToTab <| ViewDetails key
                , goTo ViewDashboard
                ]
            )
