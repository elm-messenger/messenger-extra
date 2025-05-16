module Messenger.GlobalComponents.Transition.Base exposing
    ( Transition(..), SingleTrans, DoubleTrans
    , genMixTransition, genNoMixTransition, nullTransition
    , MixTransition, NoMixTransition
    )

{-|


# Transition Base

@docs Transition, SingleTrans, DoubleTrans
@docs genMixTransition, genNoMixTransition, nullTransition
@docs MixTransition, NoMixTransition

-}

import Duration exposing (Duration)
import REGL.Common exposing (Renderable)


{-| Single Transition
-}
type alias SingleTrans =
    Renderable -> Float -> Renderable


{-| Double Transition
-}
type alias DoubleTrans =
    Renderable -> Renderable -> Float -> Renderable


{-| Null Transition
-}
nullTransition : SingleTrans
nullTransition r _ =
    r


{-| Transition has two stages:

1.  From the old scene to the transition scene
2.  From the transition scene to the new scene

-}
type alias NoMixTransition =
    { currentTransition : Float
    , outT : Float
    , inT : Float
    , outTrans : SingleTrans
    , inTrans : SingleTrans
    }


{-| Mix Transition
-}
type alias MixTransition =
    { currentTransition : Float
    , t : Float
    , trans : DoubleTrans
    }


{-| Transition
-}
type Transition
    = NMTransition NoMixTransition
    | MTransition MixTransition


{-| Generate nomix transition
-}
genNoMixTransition : ( SingleTrans, Duration ) -> ( SingleTrans, Duration ) -> Transition
genNoMixTransition ( outTrans, outT ) ( inTrans, inT ) =
    NMTransition
        { currentTransition = 0
        , outT = Duration.inMilliseconds outT
        , inT = Duration.inMilliseconds inT
        , outTrans = outTrans
        , inTrans = inTrans
        }


{-| Generate mixed transition
-}
genMixTransition : ( DoubleTrans, Duration ) -> Transition
genMixTransition ( trans, t ) =
    MTransition
        { currentTransition = 0
        , t = Duration.inMilliseconds t
        , trans = trans
        }
