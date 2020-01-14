module Model.Settings exposing
    ( Settings
    , SettingsEvent(..)
    , SpinResult
    , init
    )


type SettingsEvent
    = UpdateVehicleCount Int
    | UpdateWeaponCount Int
    | UpdateUpgradeCount Int
    | UpdatePerkCount Int
    | GenerateTeam
    | NewTeamVersion


type alias Settings =
    { percentVehicles : Int
    , percentWeapons : Int
    , percentUpgrades : Int
    , percentPerks : Int
    , pointsAllowed : Int
    , spinResults : List SpinResult
    }


type alias SpinResult =
    { summary : String
    , cost : Int
    }


init : Settings
init =
    Settings 60 30 10 0 50 []
