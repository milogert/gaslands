module Model.Upgrade.TimeExtended2 exposing (weapons)

import Model.Shared exposing (..)
import Model.Upgrade.Model exposing (..)


weapons : List Upgrade
weapons =
    [ improvedSludgeThrower
    , ejectorSeats
    , clusterBombs
    ]


improvedSludgeThrower : Upgrade
improvedSludgeThrower =
    { defaultUpgrade
        | name = "Improved Sludge Thrower"
        , slots = 1
        , specials =
            [ SpecialRule "This vehicle may place the burst templates for its dropped weapons anywhere within a 360° arc of fire that is at least partially within medium range of this vehicle."
            ]
        , cost = 1
        , expansion = TX 2
    }


ejectorSeats : Upgrade
ejectorSeats =
    { defaultUpgrade
        | name = "Ejector Seats"
        , specials =
            [ SpecialRule "When this vehicle is wrecked, an in-play vehicle from this team may immediately gain all its perks (ignoring any duplicate perks). If it does, the wrecked vehicle may not be re-spawned during this game."
            ]
        , cost = 1
        , expansion = TX 2
    }


clusterBombs : Upgrade
clusterBombs =
    { defaultUpgrade
        | name = "Cluster Bombs"
        , specials =
            [ SpecialRule "When this vehicle makes a shooting attack with a Mortar, it may choose to roll 0 attack dice to instead make a 2D6 explosion attack against every vehicle within medium range of the target vehicle, including the target vehicle."
            ]
        , cost = 1
        , expansion = TX 2
    }
