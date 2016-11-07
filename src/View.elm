module View exposing (view)

import Types exposing (Model, Msg)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [text "Time Tracker"]
        , ul [] (projectsHtml model)
        ]


projectsHtml : Model -> List (Html a)
projectsHtml model = List.map (\name -> li [] [text name])  model.projects
