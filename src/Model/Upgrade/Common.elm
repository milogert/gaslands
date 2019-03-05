module Model.Upgrade.Common exposing
    ( allUpgradesList
    , nameToUpgrade
    )

import Dict
import Model.Shared exposing (..)
import Model.Upgrade.BaseGame
import Model.Upgrade.Model exposing (Upgrade)
import Model.Upgrade.TimeExtended2


allUpgradesList : List Upgrade
allUpgradesList =
    Model.Upgrade.BaseGame.weapons
        ++ Model.Upgrade.TimeExtended2.weapons


nameToUpgrade : String -> Maybe Upgrade
nameToUpgrade name =
    allUpgradesList
        |> List.map (\u -> ( u.name, u ))
        |> Dict.fromList
        |> Dict.get name
