module View exposing (view)

import Types exposing (Model, Msg(..), Project)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Time Tracker" ]
        , div [] [ text model.apiEndpoint ]
        , div [] [ text model.projectsEndpoint ]
        , ul [] (projectsListHtml model)
        , div [] [ (projectHtml model.project) ]
        ]


projectsListHtml : Model -> List (Html Msg)
projectsListHtml model =
    List.map projectItemHtml model.projects


projectItemHtml : Maybe Project -> Html Msg
projectItemHtml project =
    case project of
        Just p ->
            li
                [ onClick (FetchProject p.url) ]
                [ text p.name ]

        Nothing ->
            li [] [ text "[error]" ]


projectHtml : Maybe Project -> Html Msg
projectHtml project =
    case project of
        Just p ->
            div []
                [ text (String.concat [ "Project : ", p.name ])
                , br [] []
                , text (String.concat [ "Total Time : ", Maybe.withDefault "[unknown]" p.totalTime ])
                ]

        Nothing ->
            text "[none selected]"
