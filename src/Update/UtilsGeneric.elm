module Update.UtilsGeneric exposing (do)

import Task


do : msg -> Cmd msg
do msg =
    Task.perform (\_ -> msg) (Task.succeed msg)
