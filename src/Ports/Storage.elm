port module Ports.Storage exposing
    ( StorageEntry
    , delete
    , deleteSub
    , get
    , getLastTeam
    , getLastTeamSub
    , getStorage
    , getStorageSub
    , getSub
    , set
    , setLastTeam
    , setLastTeamSub
    , setSub
    , share
    )


type alias StorageEntry =
    { key : String
    , name : String
    , value : String
    }


port share : String -> Cmd msg


port get : String -> Cmd msg


port getSub : (StorageEntry -> msg) -> Sub msg


port getStorage : String -> Cmd msg


port getStorageSub : (List StorageEntry -> msg) -> Sub msg


port set : StorageEntry -> Cmd msg


port setSub : (StorageEntry -> msg) -> Sub msg


port delete : String -> Cmd msg


port deleteSub : (String -> msg) -> Sub msg


port getLastTeam : String -> Cmd msg


port getLastTeamSub : (StorageEntry -> msg) -> Sub msg


port setLastTeam : String -> Cmd msg


port setLastTeamSub : (String -> msg) -> Sub msg
