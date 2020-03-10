module Update.Utils exposing (doNavClose, doSaveModel, goTo, goToTab)

import Model.Model exposing (..)
import Model.Views exposing (ViewEvent)
import Update.UtilsGeneric exposing (do)


doSaveModel : Cmd Msg
doSaveModel =
    do SaveModel


doNavClose : Cmd Msg
doNavClose =
    do <| NavToggle False


goTo : ViewEvent -> Cmd Msg
goTo viewEvent =
    do <| ViewMsg viewEvent


goToTab : ViewEvent -> Cmd Msg
goToTab viewEvent =
    do <| ViewTab viewEvent
