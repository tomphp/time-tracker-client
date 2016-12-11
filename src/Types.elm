module Types exposing (Model, Msg(..), Project)

import Http


type alias Project =
    String


type alias Model =
    { apiEndpoint : String
    , projectsEndpoint : String
    , projects : List Project
    }


type Msg
    = FetchApi (Result Http.Error String)
    | FetchProjects (Result Http.Error (List String))
