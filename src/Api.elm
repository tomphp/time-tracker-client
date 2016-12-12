module Api exposing (fetchApi, fetchUrl)

import Dict
import Http
import Json.Decode as Json
import Set
import Siren exposing (Entity, EmbeddedEntity(..), Link, linksWithClass, Value(..))
import Siren.Decode exposing (entity)
import Task
import Types exposing (Msg(..), Project)


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


projectNames : Json.Decoder (List String)
projectNames =
    Json.map (entitiesWithClass "projects" >> List.map (.properties >> Dict.get "name" >> Maybe.map valueToString >> Maybe.withDefault "Ouch")) entity


valueToString : Value -> String
valueToString v =
    case v of
        StringValue s ->
            s

        _ ->
            "[not-string]"


nullEntity : Entity
nullEntity =
    { rels = Set.empty
    , classes = Set.empty
    , properties = Dict.empty
    , links = []
    , entities = []
    , actions = []
    }


entitiesWithClass : String -> Entity -> List Entity
entitiesWithClass class entity =
    entity.entities
        |> List.filter isEntityRepresenation
        |> List.map entityRepresenation
        |> List.filter isSomething
        |> List.map (Maybe.withDefault nullEntity)


isSomething : Maybe a -> Bool
isSomething x =
    case x of
        Just _ ->
            True

        Nothing ->
            False


isEntityRepresenation : EmbeddedEntity -> Bool
isEntityRepresenation entity =
    case entity of
        EmbeddedRepresentation _ ->
            True

        EmbeddedLink _ ->
            False


entityRepresenation : EmbeddedEntity -> Maybe Entity
entityRepresenation entity =
    case entity of
        EmbeddedRepresentation record ->
            Just record

        EmbeddedLink record ->
            Nothing
