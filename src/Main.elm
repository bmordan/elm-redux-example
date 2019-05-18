import Time exposing (Posix)
import Browser
import Html exposing (Html, node, div, text, button)
import Html.Attributes exposing (style, min, max, value)
import Html.Events exposing (onClick)

main = Browser.element
    {
        init = init
        ,subscriptions = subscriptions
        , update = update
        , view = view
    }

type alias Model =
    { 
        hunger: Int
        ,engagement: Int
        ,wellbeing: Int
        ,emoji: String
    }

init : () -> (Model, Cmd Msg)
init _ =
    (Model 50 50 0 ":|", Cmd.none)

type Msg =
    Feed | Play | Tick Posix

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 100 Tick

update msg model =
    case msg of
        Feed ->
            ({model | hunger = model.hunger - 10 }, Cmd.none)
        Play ->
            ({model | engagement = model.engagement + 10}, Cmd.none)
        Tick _ ->
            let
                wellbeing = model.wellbeing - model.hunger + model.engagement
                emoji = if wellbeing > model.wellbeing then ":)" else ":("
            in
                ({model | 
                    hunger = model.hunger + 1
                    ,engagement = model.engagement - 1
                    ,wellbeing = wellbeing
                    ,emoji = emoji
                }, Cmd.none)
        
view model =
    div [][
        node "samp" [
            style "display" "inline-block"
            ,style "font-size" "12rem"
            ,style "transform" "rotate(90deg)"
        ][text model.emoji]
        , node "meter" [min "0", max "100", value (String.fromInt model.hunger)][]
        , button [onClick Feed][text "Feed"]
        , node "meter" [min "0", max "100", value (String.fromInt model.engagement)][]
        , button [onClick Play][text "Play"]
    ]