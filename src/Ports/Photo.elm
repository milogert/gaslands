port module Ports.Photo exposing (getStream, takePhoto, getPhotoUrl)


port getStream : String -> Cmd msg


port takePhoto : String -> Cmd msg


port getPhotoUrl : (String -> msg) -> Sub msg
