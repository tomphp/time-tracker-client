port module Main exposing (..)

import Test exposing (describe)
import Tests
import ApiSpec
import Test.Runner.Node exposing (run)
import Json.Encode exposing (Value)


main : Program Value
main =
    run emit
        (describe "Test"
            [ Tests.all
            , ApiSpec.all
            ])


port emit : ( String, Value ) -> Cmd msg
