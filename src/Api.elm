module Api exposing (fetchApi, fetchUrl)

import Types exposing (Msg(..), Project)
import Http
import Json.Decode as Json
import Task
import Set
import Siren.Decode exposing (entity)
import Siren exposing (Entity(..), Link, linksWithClass)


apiUrl : String
apiUrl =
    "http://time-tracker-e2e-tests.cfapps.io/api/v1"


fetchApi : Cmd Msg
fetchApi =
    Http.get apiUrl decodeApi |> Http.send FetchApi


fetchUrl : String -> Cmd Msg
fetchUrl url =
    Http.get url (Json.succeed [ "Project1" ]) |> Http.send FetchProjects


decodeApi : Json.Decoder String
decodeApi =
    Json.map (linkHref "projects") entity


linkHref : String -> Entity -> String
linkHref class entity =
    linksWithClass class entity
        |> List.head
        |> Maybe.withDefault (Link Set.empty Set.empty "not found" Nothing Nothing)
        |> .href
