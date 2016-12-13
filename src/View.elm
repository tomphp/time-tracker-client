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
        , ul [] (projectsHtml model)
        ]


projectsHtml : Model -> List (Html Msg)
projectsHtml model =
    List.map projectHtml model.projects


projectHtml : Maybe Project -> Html Msg
projectHtml project =
    case project of
        Just p ->
            li
                [ onClick (FetchProject p.url) ]
                [ span [] [ text p.name ]
                , span [] [ text p.url ]
                ]

        Nothing ->
            li [] [ text "[error]" ]
