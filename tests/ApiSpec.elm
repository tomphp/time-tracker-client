module ApiSpec exposing (..)

import Test exposing (..)
import Expect

all : Test
all =
    describe "Api"
        [ test "API URL" <|
            \() ->
                Expect.equal 1 1
        ]
