module Model.Upgrade.Model exposing
    ( Upgrade
    , UpgradeEvent(..)
    , defaultUpgrade
    )

import Model.Shared exposing (..)


type UpgradeEvent
    = AddUpgrade String Upgrade
    | DeleteUpgrade String Upgrade
    | TmpUpgradeUpdate String


type alias Upgrade =
    { name : String
    , slots : Int
    , specials : List Special
    , cost : Int
    , expansion : Expansion
    }


defaultUpgrade : Upgrade
defaultUpgrade =
    Upgrade "" 0 [] 0 BaseGame
