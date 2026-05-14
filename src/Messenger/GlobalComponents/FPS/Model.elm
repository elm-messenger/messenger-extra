module Messenger.GlobalComponents.FPS.Model exposing (InitOption, genGC)

{-| Global component configuration module

A Global Component to show FPS at the corner

@docs InitOption, genGC

-}

import Color
import Json.Encode as E
import Messenger.Base exposing (UserEvent(..))
import Messenger.Component.GlobalComponent exposing (genGlobalComponent)
import Messenger.Scene.Scene exposing (ConcreteGlobalComponent, GCTarget, GlobalComponentInit, GlobalComponentStorage, GlobalComponentUpdate, GlobalComponentUpdateRec, GlobalComponentView)
import REGL.BuiltinPrograms as P


{-| Init Options
-}
type alias InitOption =
    { fontSize : Float
    , font : String
    }


type alias Data =
    { lastTenTime : List Float
    , fps : Float
    , size : Float
    , font : String
    }


init : InitOption -> GlobalComponentInit userdata scenemsg Data
init opt _ _ _ =
    ( { lastTenTime = []
      , fps = 0
      , size = opt.fontSize
      , font = opt.font
      }
    , { dead = False
      , postProcessor = identity
      }
    )


update : GlobalComponentUpdate userdata scenemsg Data
update _ env evnt data bdata =
    case evnt of
        Tick delta ->
            let
                lastTimes =
                    (if List.length data.lastTenTime == 10 then
                        Maybe.withDefault [] <| List.tail data.lastTenTime

                     else
                        data.lastTenTime
                    )
                        ++ [ delta ]

                sum =
                    List.sum lastTimes

                fps =
                    toFloat (List.length lastTimes) / sum * 1000
            in
            ( ( { data | lastTenTime = lastTimes, fps = fps }, bdata ), [], ( env, False ) )

        _ ->
            ( ( data, bdata ), [], ( env, False ) )


updaterec : GlobalComponentUpdateRec userdata scenemsg Data
updaterec _ env _ data bdata =
    ( ( data, bdata ), [], env )


view : GlobalComponentView userdata scenemsg Data
view _ _ data _ =
    P.textbox ( 0, 0 ) data.size ("FPS: " ++ String.fromInt (floor data.fps)) data.font (Color.rgba 0 0 0 0.5)


gcCon : InitOption -> ConcreteGlobalComponent Data userdata scenemsg
gcCon opt =
    { init = init opt
    , update = update
    , updaterec = updaterec
    , view = view
    , id = "fps"
    }


{-| Generate a global component.
-}
genGC : InitOption -> Maybe GCTarget -> GlobalComponentStorage userdata scenemsg
genGC opt =
    genGlobalComponent (gcCon opt) E.null
