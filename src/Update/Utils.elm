module Update.Utils exposing (doCloseModal, doSaveModel)

import Model.Model exposing (..)
import Task


doOtherMsg : Msg -> Cmd Msg
doOtherMsg msg =
    Task.perform (\_ -> msg) (Task.succeed msg)


doSaveModel : Cmd Msg
doSaveModel =
    doOtherMsg SaveModel


doCloseModal : String -> Cmd Msg
doCloseModal modal =
    doOtherMsg (CloseModal modal)
