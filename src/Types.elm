module Types exposing (Model, Msg(..), Project, Developer, TimeEntry)

import Http


type alias Project =
    { name : String
    , url : String
    , totalTime : Maybe String
    , entries : List TimeEntry
    }


type alias TimeEntry =
    { date : String
    , period : String
    , description : String
    }


type alias Developer =
    { name : String
    , email : String
    , url : String
    }


type alias Model =
    { apiEndpoint : String
    , projectsEndpoint : Maybe String
    , developersEndpoint : Maybe String
    , projects : List (Maybe Project)
    , project : Maybe Project
    , developers : List (Maybe Developer)
    }


type Msg
    = IndexFetched (Result Http.Error ( String, String ))
    | ProjectsFetched (Result Http.Error (List (Maybe Project)))
    | FetchProject String
    | ProjectFetched (Result Http.Error (Maybe Project))
    | DevelopersFetched (Result Http.Error (List (Maybe Developer)))
