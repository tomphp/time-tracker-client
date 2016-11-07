module Api exposing (fetchApi, fetchProjects)

import Types exposing (Msg (..))
import Http
import Json.Decode as Json
import Task

apiUrl : String
apiUrl = "http://time-tracker-app.cfapps.io/api/v1"


fetchApi : Cmd Msg
fetchApi = Task.perform FetchFail FetchApiSucceed (Http.get decodeApi apiUrl)


decodeApi : Json.Decoder String
decodeApi = Json.at ["data", "relationships", "projects", "links", "related"] Json.string


fetchProjects : String -> Cmd Msg
fetchProjects url = Task.perform FetchFail FetchProjectsSucceed (Http.get decodeProjects url)


decodeProjects : Json.Decoder (List String)
decodeProjects = Json.at ["data"] (Json.list decodeProject)


decodeProject : Json.Decoder String
decodeProject = Json.at ["attributes", "name"] Json.string
