module Main exposing (main)

---- IMPORTS -------------------------------------------------------------------

import Browser
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Scrapscript exposing (Scrap(..))
import Task



---- MAIN ----------------------------------------------------------------------


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



---- MODEL ---------------------------------------------------------------------


type alias Model =
    { input : String
    , output : Result String Scrap
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "1 + 2", output = Ok (Int 3) }
    , Cmd.none
    )



---- UPDATE --------------------------------------------------------------------


type Msg
    = Change String
    | Run (Result String Scrap)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInput ->
            ( { model | input = newInput }
            , Task.perform (\_ -> Run (Scrapscript.run Dict.empty newInput)) (Task.succeed ())
            )

        Run result ->
            ( { model | output = result }
            , Cmd.none
            )



---- SUBSCRIPTIONS -------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



---- VIEW ----------------------------------------------------------------------


view : Model -> Html Msg
view model =
    div
        [ style "display" "grid"
        , style "grid-template-columns" "1fr 1fr"
        , style "height" "100vh"
        ]
        [ textarea
            [ placeholder "1 + 2"
            , value model.input
            , onInput Change
            , style "height" "100%"
            , style "resize" "none"
            , style "padding" "10px"
            , style "border" "1px solid #ccc"
            , style "font-family" "monospace"
            ]
            []
        , pre
            [ style "height" "100%"
            , style "margin" "0"
            , style "padding" "10px"
            , style "background-color" "#f0f0f0"
            , style "overflow" "auto"
            , style "border" "1px solid #ccc"
            ]
            [ text <|
                case model.output of
                    Ok scrap ->
                        Scrapscript.toString scrap

                    Err err ->
                        err
            ]
        ]
