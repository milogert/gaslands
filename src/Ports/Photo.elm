port module Ports.Photo exposing (destroyStream, getPhotoUrl, getStream, takePhoto)


port getStream : String -> Cmd msg


port takePhoto : String -> Cmd msg


port destroyStream : String -> Cmd msg


port getPhotoUrl : (String -> msg) -> Sub msg
