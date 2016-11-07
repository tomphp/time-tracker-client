module State exposing (init, update, subscriptions)

import Api exposing (fetchApi, fetchProjects)
import Types exposing (Model, Msg (..))

init : (Model, Cmd Msg)
init = (initialModel , fetchApi)


initialModel : Model
initialModel = Model []


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchApiSucceed url ->
            (model, fetchProjects url)

        FetchProjectsSucceed projects ->
            (Model projects, Cmd.none)

        FetchFail _ ->
            (model, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
