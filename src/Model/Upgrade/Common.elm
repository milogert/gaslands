module Model.Upgrade.Common exposing
    ( allUpgradesList
    , nameToUpgrade
    )

import Dict
import Model.Shared exposing (..)
import Model.Upgrade exposing (Upgrade)
import Model.Upgrade.BaseGame


allUpgradesList : List Upgrade
allUpgradesList =
    Model.Upgrade.BaseGame.upgrades


nameToUpgrade : String -> Maybe Upgrade
nameToUpgrade name =
    allUpgradesList
        |> List.map (\u -> ( u.name, u ))
        |> Dict.fromList
        |> Dict.get name
