module Messenger.GlobalComponents.Transition.Transitions exposing
    ( fadeIn, fadeInWithColor, fadeInWithRenderable, fadeOut, fadeOutWithColor, fadeOutWithRenderable
    , fadeMix, fadeImgMix
    , fadeOutImg, fadeInImg
    )

{-|


# Builtin Transitions

@docs fadeIn, fadeInWithColor, fadeInWithRenderable, fadeOut, fadeOutWithColor, fadeOutWithRenderable
@docs fadeMix, fadeImgMix
@docs fadeOutImg, fadeInImg

-}

import Color
import Messenger.GlobalComponents.Transition.Base exposing (DoubleTrans, SingleTrans)
import REGL.BuiltinPrograms as P
import REGL.Common exposing (Renderable)
import REGL.Compositors as Comp


{-| Fade out transition.
-}
fadeOut : SingleTrans
fadeOut r t =
    Comp.linearFade t r (P.clear Color.black)


{-| Fade in transition.
-}
fadeIn : SingleTrans
fadeIn r t =
    Comp.linearFade t (P.clear Color.black) r


{-| Fade out transition using mask image.
-}
fadeOutImg : String -> Bool -> SingleTrans
fadeOutImg mask invert r t =
    Comp.imgFade mask t invert r (P.clear Color.black)


{-| Fade in transition using mask image.
-}
fadeInImg : String -> Bool -> SingleTrans
fadeInImg mask invert r t =
    Comp.imgFade mask t invert (P.clear Color.black) r


{-| Fade out transition with a color.
-}
fadeOutWithColor : Color.Color -> SingleTrans
fadeOutWithColor c r t =
    Comp.linearFade t r (P.clear c)


{-| Fade in transition with a color.
-}
fadeInWithColor : Color.Color -> SingleTrans
fadeInWithColor c r t =
    Comp.linearFade t (P.clear c) r


{-| Fade out transition with a renderable.
-}
fadeOutWithRenderable : Renderable -> SingleTrans
fadeOutWithRenderable c r t =
    Comp.linearFade t r c


{-| Fade in transition with a renderable.
-}
fadeInWithRenderable : Renderable -> SingleTrans
fadeInWithRenderable c r t =
    Comp.linearFade t c r


{-| Fading transition used in mixed mode.
-}
fadeMix : DoubleTrans
fadeMix r1 r2 t =
    Comp.linearFade t r1 r2


{-| Fading transition based on mask image used in mixed mode.
-}
fadeImgMix : String -> Bool -> DoubleTrans
fadeImgMix mask invert r1 r2 t =
    Comp.imgFade mask t invert r1 r2
