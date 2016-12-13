module Api exposing (fetchApi, fetchUrl)

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


fetchApi : Cmd Msg
fetchApi =
    Http.get apiUrl decodeApi |> Http.send FetchApi


fetchUrl : String -> Cmd Msg
fetchUrl url =
    Http.get url projectNames |> Http.send FetchProjects


decodeApi : Json.Decoder String
decodeApi =
    Json.map (linkWithClassHref "projects") entity


linkWithClassHref : String -> Entity -> String
linkWithClassHref class entity =
    linksWithClass class entity
        |> List.head
        |> Maybe.withDefault (Link Set.empty Set.empty "not found" Nothing Nothing)
        |> .href


projectNames : Json.Decoder (List (Maybe Project))
projectNames =
    Json.map
        (entitiesWithClass "project"
            >> List.map
                (\e ->
                    Maybe.map Project (entityRepresenation e |> Maybe.andThen projectName)
                        |> Maybe.Extra.andMap (entityRepresenation e |> Maybe.andThen projectHref)
                )
        )
        entity


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
