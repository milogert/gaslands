module Model.Settings exposing
    ( ExpansionTracker
    , Settings
    , SettingsEvent(..)
    , SpinResult
    , init
    )

import Model.Shared exposing (Expansion(..))


type SettingsEvent
    = UpdateVehicleCount Int
    | UpdateWeaponCount Int
    | UpdateUpgradeCount Int
    | UpdatePerkCount Int
    | GenerateTeam
    | EnableExpansion Expansion Bool


type alias Settings =
    { percentVehicles : Int
    , percentWeapons : Int
    , percentUpgrades : Int
    , percentPerks : Int
    , pointsAllowed : Int
    , spinResults : List SpinResult
    , expansions : ExpansionTracker
    }


type alias SpinResult =
    { summary : String
    , cost : Int
    }


type alias ExpansionTracker =
    { enabled : List Expansion
    , available : List Expansion
    }


init : Settings
init =
    Settings 60 30 10 0 50 [] initExpansionTracker


initExpansionTracker : ExpansionTracker
initExpansionTracker =
    ExpansionTracker [ BaseGame ]
        [ BaseGame, TX 2 ]
