module Types exposing (Model, Msg(..), Project)

import Http


type alias Project =
    { name : String
    , url : String
    }


type alias Model =
    { apiEndpoint : String
    , projectsEndpoint : String
    , projects : List (Maybe Project)
    , project : Maybe Project
    }


type Msg
    = IndexFetched (Result Http.Error String)
    | ProjectsFetched (Result Http.Error (List (Maybe Project)))
    | FetchProject String
    | ProjectFetched (Result Http.Error Project)
