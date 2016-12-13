module State exposing (init, update, subscriptions)

import Api exposing (fetchIndex, fetchProjects, fetchProject)
import Types exposing (Model, Msg(..))


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchIndex )


initialModel : Model
initialModel =
    { apiEndpoint = "http://time-tracker-e2e-tests.cfapps.io/api/v1"
    , projectsEndpoint = ""
    , projects = []
    , project = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchApi (Ok url) ->
            ( { model | projectsEndpoint = url }, fetchProjects url )

        FetchApi (Err _) ->
            ( model, Cmd.none )

        FetchProjects (Ok projects) ->
            ( { model | projects = projects }, Cmd.none )

        FetchProjects (Err _) ->
            ( model, Cmd.none )

        FetchProject url ->
            ( model, fetchProject url )

        ProjectFetched (Ok project) ->
            ( { model | project = Just project }, Cmd.none )

        ProjectFetched (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
