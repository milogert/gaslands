port module Ports.Storage exposing
    ( StorageEntry
    , delete
    , deleteSub
    , get
    , getStorage
    , getStorageSub
    , getSub
    , set
    , setSub
    , share
    )


type alias StorageEntry =
    { key : String
    , value : String
    }


port share : String -> Cmd msg


port get : String -> Cmd msg


port getSub : (String -> msg) -> Sub msg


port getStorage : String -> Cmd msg


port getStorageSub : (List ( String, String ) -> msg) -> Sub msg


port set : StorageEntry -> Cmd msg


port setSub : (StorageEntry -> msg) -> Sub msg


port delete : String -> Cmd msg


port deleteSub : (String -> msg) -> Sub msg
