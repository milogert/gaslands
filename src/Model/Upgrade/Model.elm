module Model.Upgrade.Model exposing
    ( Upgrade
    , defaultUpgrade
    )

import Model.Shared exposing (..)


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
