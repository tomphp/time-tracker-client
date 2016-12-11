module State exposing (init, update, subscriptions)

import Api exposing (fetchApi, fetchUrl)
import Types exposing (Model, Msg(..))


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchApi )


initialModel : Model
initialModel =
    { apiEndpoint = "http://time-tracker-e2e-tests.cfapps.io/api/v1"
    , projectsEndpoint = ""
    , projects = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchApi (Ok url) ->
            ( { model | projectsEndpoint = url }, fetchUrl url )

        FetchApi (Err _) ->
            ( model, Cmd.none )

        FetchProjects (Ok projects) ->
            ( { model | projects = projects }, Cmd.none )

        FetchProjects (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
