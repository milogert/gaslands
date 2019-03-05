module Update.Utils exposing (doSaveModel)

import Model.Model exposing (..)
import Task


doSaveModel : Cmd Msg
doSaveModel =
    Task.perform (\_ -> SaveModel) (Task.succeed SaveModel)
