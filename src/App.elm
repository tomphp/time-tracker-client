module App exposing (main)

import State exposing (..)
import View exposing (..)
import Html.App as HtmlApp

main : Program Never
main = HtmlApp.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

