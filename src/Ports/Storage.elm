port module Ports.Storage exposing
    ( StorageEntry
    , delete
    , deleteSub
    , get
    , getKeys
    , getKeysSub
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


port getKeys : String -> Cmd msg


port getKeysSub : (List String -> msg) -> Sub msg


port set : StorageEntry -> Cmd msg


port setSub : (StorageEntry -> msg) -> Sub msg


port delete : String -> Cmd msg


port deleteSub : (String -> msg) -> Sub msg
