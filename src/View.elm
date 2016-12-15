module View exposing (view)

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
        , div []
            [ (projectItemHtml model.project)
            , ul [] (timeEntryListHtml model)
            ]
        ]


projectListHtml : Model -> List (Html Msg)
projectListHtml model =
    List.map projectItemHtml model.projects


developerListHtml : Model -> List (Html Msg)
developerListHtml model =
    List.map developerItemHtml model.developers


timeEntryListHtml : Model -> List (Html Msg)
timeEntryListHtml model =
    Maybe.map .entries model.project
        |> Maybe.withDefault []
        |> List.map timeEntryItemHtml


projectItemHtml : Maybe Project -> Html Msg
projectItemHtml project =
    case project of
        Just p ->
            li
                [ onClick (FetchProject p.url) ]
                [ text p.name ]

        Nothing ->
            li [] [ text "[error]" ]


developerItemHtml : Maybe Developer -> Html Msg
developerItemHtml developer =
    case developer of
        Just d ->
            li [] [ text d.name, text " - ", text d.email ]

        Nothing ->
            li [] [ text "[error]" ]


timeEntryItemHtml : TimeEntry -> Html Msg
timeEntryItemHtml entry =
    div []
        [ text entry.date
        , text entry.period
        , text entry.description
        ]
