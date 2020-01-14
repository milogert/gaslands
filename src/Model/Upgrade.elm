module Model.Upgrade exposing
    ( Upgrade
    , UpgradeEvent(..)
    , defaultUpgrade
    )

import Model.Shared exposing (..)
import Model.Sponsors exposing (Sponsor)


type UpgradeEvent
    = AddUpgrade String Upgrade
    | DeleteUpgrade String Upgrade
    | TmpUpgradeUpdate String


type alias Upgrade =
    { name : String
    , slots : Int
    , specials : List Special
    , cost : Int
    , requiredSponsor : Maybe Sponsor
    }


defaultUpgrade : Upgrade
defaultUpgrade =
    Upgrade "TODO" 0 [] 0 Nothing
