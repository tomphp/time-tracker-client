module Api exposing (fetchIndex, fetchProjects, fetchProject)

import Dict
import Http
import Json.Decode as Json
import Maybe.Extra
import Set
import Siren.Decode exposing (entity)
import Siren.Entity
    exposing
        ( Entity
        , EmbeddedEntity(..)
        , Link
        , Rels
        , Classes
        , linksWithClass
        , linksWithRel
        , linksWithClass
        , embeddedEntitiesWithClass
        , embeddedEntities
        , firstLinkWithRel
        , propertyString
        )
import Siren.Value exposing (Value(..))
import Task
import Types exposing (Msg(..), Project)


apiUrl : String
apiUrl =
    "http://time-tracker-e2e-tests.cfapps.io/api/v1"


fetchIndex : Cmd Msg
fetchIndex =
    Http.get apiUrl index |> Http.send IndexFetched


fetchProjects : String -> Cmd Msg
fetchProjects url =
    Http.get url projects |> Http.send ProjectsFetched


fetchProject : String -> Cmd Msg
fetchProject url =
    Http.get url project |> Http.send ProjectFetched


index : Json.Decoder String
index =
    Json.map (linkWithClassHref "projects") entity


linkWithClassHref : String -> Entity -> String
linkWithClassHref class entity =
    linksWithClass class entity
        |> List.head
        |> Maybe.withDefault (Link Set.empty Set.empty "not found" Nothing Nothing)
        |> .href


projects : Json.Decoder (List (Maybe Project))
projects =
    Json.map
        (embeddedEntitiesWithClass "project" >> List.map entityToProject)
        entity


project : Json.Decoder (Maybe Project)
project =
    entity |> Json.map entityToProject


entityToProject : Entity -> Maybe Project
entityToProject entity =
    Maybe.map Project (propertyString "name" entity)
        |> Maybe.Extra.andMap (firstLinkWithRel "self" entity |> Maybe.map .href)
        |> Maybe.Extra.andMap (propertyString "total_time" entity |> Maybe.map Just)
