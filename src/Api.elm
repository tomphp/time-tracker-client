module Api exposing (fetchIndex, fetchProjects, fetchProject, fetchDevelopers)

import Dict exposing (..)
import Http
import Json.Decode as Json
import List.Extra
import Maybe.Extra
import Set
import Siren.Decode exposing (entity)
import Siren.Entity
    exposing
        ( Entity
        , EmbeddedEntity(..)
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
import Types exposing (Msg(..), Project, Developer, TimeEntry)


apiUrl : String
apiUrl =
    "http://time-tracker-e2e-tests.cfapps.io/api/v1"


fetchIndex : Cmd Msg
fetchIndex =
    Http.get apiUrl index |> Http.send IndexFetched


fetchProjects : String -> Cmd Msg
fetchProjects url =
    Http.get url projects |> Http.send ProjectsFetched


fetchDevelopers : String -> Cmd Msg
fetchDevelopers url =
    Http.get url developers |> Http.send DevelopersFetched


fetchProject : String -> Cmd Msg
fetchProject url =
    Http.get url project |> Http.send ProjectFetched


index : Json.Decoder ( String, String )
index =
    Json.map2 (,)
        (Json.map (linkWithClassHref "projects") entity)
        (Json.map (linkWithClassHref "developers") entity)


linkWithClassHref : String -> Entity -> String
linkWithClassHref class =
    linksWithClass class
        >> List.head
        >> Maybe.map .href
        >> Maybe.withDefault "not found"


projects : Json.Decoder (Dict String Project)
projects =
    Json.map (embeddedEntitiesWithClass "project" >> List.map entityToProject) entity
        |> Json.map (List.filterMap identity)
        |> Json.map (listToDict .id)


listToDict : (a -> comparable) -> List a -> Dict comparable a
listToDict f list =
    Dict.fromList <| List.Extra.zip (List.map f list) list


developers : Json.Decoder (List Developer)
developers =
    Json.map
        (embeddedEntitiesWithClass "developer" >> List.map entityToDeveloper)
        entity
        |> Json.map (List.filterMap identity)


project : Json.Decoder (Maybe Project)
project =
    entity |> Json.map entityToProject


entityToProject : Entity -> Maybe Project
entityToProject entity =
    Maybe.map Project (propertyString "id" entity)
        |> Maybe.Extra.andMap (propertyString "name" entity)
        |> Maybe.Extra.andMap (firstLinkWithRel "self" entity |> Maybe.map .href)
        |> Maybe.Extra.andMap (propertyString "total_time" entity |> Maybe.map Just)
        |> Maybe.map
            ((|>) (embeddedEntitiesWithClass "time-entry" entity |> List.map entityToTimeEntry))


entityToDeveloper : Entity -> Maybe Developer
entityToDeveloper entity =
    Maybe.map Developer (propertyString "name" entity)
        |> Maybe.Extra.andMap (propertyString "email" entity)
        |> Maybe.Extra.andMap (firstLinkWithRel "self" entity |> Maybe.map .href)


entityToTimeEntry : Entity -> TimeEntry
entityToTimeEntry entity =
    { date = propertyString "date" entity |> Maybe.withDefault "[unknown]"
    , period = propertyString "period" entity |> Maybe.withDefault "[unknown]"
    , description = propertyString "description" entity |> Maybe.withDefault "[unknown]"
    }
