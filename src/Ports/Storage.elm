port module Ports.Storage exposing (StorageEntry, get, getSub, getKeys, getKeysSub, set, setSub, delete, deleteSub)


type alias StorageEntry =
    { key : String
    , value : String
    }


port get : String -> Cmd msg


port getSub : (String -> msg) -> Sub msg


port getKeys : String -> Cmd msg


port getKeysSub : (List String -> msg) -> Sub msg


port set : StorageEntry -> Cmd msg


port setSub : (StorageEntry -> msg) -> Sub msg


port delete : String -> Cmd msg


port deleteSub : (String -> msg) -> Sub msg
