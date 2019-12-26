module Model.Views exposing (NewType(..), ViewEvent(..))


type ViewEvent
    = ViewDashboard
    | ViewNew NewType
    | ViewDetails String
    | ViewSponsor
    | ViewPrintAll
    | ViewPrint String
    | ViewSettings


type NewType
    = NewVehicle
    | NewWeapon String
    | NewUpgrade String
