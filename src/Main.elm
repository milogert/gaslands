module Main exposing (main)

import Browser
import Model.Model as Model exposing (Model, Msg(..))
import Subscriptions.Subscriptions as Subscriptions
import Update.Update as Update
import View.View as View


main : Program () Model Msg
main =
    Browser.document
        { init = Model.init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
