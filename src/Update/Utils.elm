module Update.Utils exposing (doOtherMsg, doSaveModel, goTo)

import Model.Model exposing (..)
import Model.Views exposing (ViewEvent)
import Task


doOtherMsg : Msg -> Cmd Msg
doOtherMsg msg =
    Task.perform (\_ -> msg) (Task.succeed msg)


doSaveModel : Cmd Msg
doSaveModel =
    doOtherMsg SaveModel


goTo : ViewEvent -> Cmd Msg
goTo viewEvent =
    doOtherMsg <| ViewMsg viewEvent
