module Types exposing (Model, Msg (..))

import Http

type alias Project =
    { name : String
    , id : String
    }

type alias Model =
    { projects : List String
    }


type Msg = FetchApiSucceed String
         | FetchProjectsSucceed (List String)
         | FetchFail Http.Error
