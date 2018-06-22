port module Ports.Ports exposing (exportModel, share)


port exportModel : String -> Cmd msg
port share : String -> Cmd msg
