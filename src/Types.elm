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
    = FetchApi (Result Http.Error String)
    | FetchProjects (Result Http.Error (List (Maybe Project)))
    | FetchProject String
    | ProjectFetched (Result Http.Error Project)
