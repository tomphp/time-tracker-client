module View exposing (view)

import Dict exposing (..)
import Types exposing (Model, Msg(..), Project, Developer, TimeEntry)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Time Tracker" ]
        , div [] [ text model.apiEndpoint ]
        , div [] [ text <| Maybe.withDefault "loading..." model.projectsEndpoint ]
        , div [] [ text <| Maybe.withDefault "loading..." model.developersEndpoint ]
        , ul [] (projectListHtml model)
        , ul [] (developerListHtml model)
        , projectHtml model.project
        ]


projectHtml : Maybe Project -> Html Msg
projectHtml project =
    case project of
        Just p ->
            div []
                [ projectItemHtml p
                , timeEntryListHtml p
                ]

        Nothing ->
            text ""


projectListHtml : Model -> List (Html Msg)
projectListHtml model =
    List.map projectItemHtml <| Dict.values model.projects


developerListHtml : Model -> List (Html Msg)
developerListHtml model =
    List.map developerItemHtml model.developers


timeEntryListHtml : Project -> Html Msg
timeEntryListHtml project =
    table [] <| List.map timeEntryItemHtml project.entries


projectItemHtml : Project -> Html Msg
projectItemHtml project =
    li
        [ onClick (FetchProject project.url) ]
        [ text project.name ]


developerItemHtml : Developer -> Html Msg
developerItemHtml developer =
    li [] [ text developer.name, text " - ", text developer.email ]


timeEntryItemHtml : TimeEntry -> Html Msg
timeEntryItemHtml entry =
    tr []
        [ td [] [ text entry.date ]
        , td [] [ text entry.period ]
        , td [] [ text entry.description ]
        ]
