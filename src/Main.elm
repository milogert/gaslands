module Main exposing (main)

import Browser
import Html
import Model.Model as Model exposing (Model, Msg(..), init)
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
