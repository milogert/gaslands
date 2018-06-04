port module Ports.Ports exposing (exportModel)


import Model.Model exposing (..)

port exportModel : String -> Cmd msg
