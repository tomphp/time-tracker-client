module Api exposing (fetchIndex, fetchProjects, fetchProject)

import Dict
import Http
import Json.Decode as Json
import Set
import Siren exposing (Entity, EmbeddedEntity(..), Link, linksWithClass, linksWithRel, Value(..))
import Siren.Decode exposing (entity)
import Task
import Types exposing (Msg(..), Project)
import Maybe.Extra


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
        (entitiesWithClass "project"
            >> List.map
                (\e ->
                    Maybe.map Project (entityRepresenation e |> Maybe.andThen projectName)
                        |> Maybe.Extra.andMap (entityRepresenation e |> Maybe.andThen projectHref)
                )
        )
        entity


project : Json.Decoder Project
project =
    Json.map2
        Project
        (Json.at [ "properties", "name" ] Json.string)
        (Json.succeed "href")


projectName : Entity -> Maybe String
projectName e =
    e.properties
        |> Dict.get "name"
        |> Maybe.andThen valueToString


projectHref : Entity -> Maybe String
projectHref e =
    linksWithRel "self" e
        |> List.head
        |> Maybe.map .href


entitiesWithClass : String -> Entity -> List EmbeddedEntity
entitiesWithClass class entity =
    List.filter (entityRecord >> hasClass class) entity.entities


entityRecord : EmbeddedEntity -> { rels : Siren.Rels, classes : Siren.Classes }
entityRecord e =
    case e of
        EmbeddedRepresentation r ->
            { rels = r.rels, classes = r.classes }

        EmbeddedLink r ->
            { rels = r.rels, classes = r.classes }


hasClass : String -> { a | classes : Siren.Classes } -> Bool
hasClass class subject =
    subject.classes |> Set.member class


valueToString : Value -> Maybe String
valueToString v =
    case v of
        StringValue s ->
            Just s

        _ ->
            Nothing


entityRepresenation : EmbeddedEntity -> Maybe Entity
entityRepresenation entity =
    case entity of
        EmbeddedRepresentation record ->
            Just record

        EmbeddedLink record ->
            Nothing
