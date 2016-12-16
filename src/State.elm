module State exposing (init, update, subscriptions)

import Api
    exposing
        ( fetchIndex
        , fetchProjects
        , fetchProject
        , fetchProjects
        , fetchDevelopers
        )
import Dict
import Types exposing (Model, Msg(..))


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchIndex )


initialModel : Model
initialModel =
    { apiEndpoint = "http://time-tracker-e2e-tests.cfapps.io/api/v1"
    , projectsEndpoint = Nothing
    , developersEndpoint = Nothing
    , projects = Dict.empty
    , project = Nothing
    , developers = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IndexFetched (Ok ( projects, developers )) ->
            { model
                | projectsEndpoint = Just projects
                , developersEndpoint = Just developers
            }
                ! [ fetchProjects projects
                  , fetchDevelopers developers
                  ]

        IndexFetched (Err _) ->
            ( model, Cmd.none )

        ProjectsFetched (Ok projects) ->
            ( { model | projects = projects }, Cmd.none )

        ProjectsFetched (Err _) ->
            ( model, Cmd.none )

        FetchProject url ->
            ( model, fetchProject url )

        ProjectFetched (Ok project) ->
            ( { model | project = project }, Cmd.none )

        ProjectFetched (Err _) ->
            ( model, Cmd.none )

        DevelopersFetched (Ok developers) ->
            ( { model | developers = developers }, Cmd.none )

        DevelopersFetched (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
