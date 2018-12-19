module Update.Upgrade exposing (addUpgrade, deleteUpgrade)

import Model.Model exposing (..)
import Model.Upgrades exposing (..)
import Model.Vehicles exposing (..)
import Update.Utils


addUpgrade : Model -> Vehicle -> Upgrade -> ( Model, Cmd Msg )
addUpgrade model v u =
    let
        upgradeList =
            v.upgrades ++ [ { u | id = List.length v.upgrades } ]

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        vehicleNew =
            { v | upgrades = upgradeList }

        newvehicles =
            pre ++ vehicleNew :: post
    in
    ( { model
        | view = Details vehicleNew
        , error = []
        , vehicles = newvehicles
      }
    , Cmd.none
    )


deleteUpgrade : Model -> Vehicle -> Upgrade -> ( Model, Cmd Msg )
deleteUpgrade model v u =
    let
        upgradesNew =
            Update.Utils.deleteFromList u.id v.upgrades |> Update.Utils.correctIds

        vehicleUpdated =
            { v | upgrades = upgradesNew }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = Details vehicleUpdated, vehicles = vehiclesNew }
    , Cmd.none
    )
