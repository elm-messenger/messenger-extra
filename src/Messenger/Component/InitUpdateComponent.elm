module Messenger.Component.InitUpdateComponent exposing
    ( ConcreteIUComponent
    , genIUComponent
    )

{-| IU Component

@docs ConcreteIUComponent
@docs genIUComponent

-}

import Messenger.Component.Component exposing (ComponentInit, ComponentMatcher, ComponentStorage, ComponentUpdate, ComponentUpdateRec, ComponentView, ConcreteUserComponent)
import Messenger.GeneralModel exposing (abstract)


{-| InitUpdateComponent
-}
type alias ConcreteIUComponent cdata data userdata tar msg bdata scenemsg =
    { init : ComponentInit cdata userdata msg data bdata
    , initUpdate : ComponentUpdate cdata data userdata scenemsg tar msg bdata
    , update : ComponentUpdate cdata data userdata scenemsg tar msg bdata
    , updaterec : ComponentUpdateRec cdata data userdata scenemsg tar msg bdata
    , view : ComponentView cdata userdata data bdata
    , matcher : ComponentMatcher data bdata tar
    }


resMap : ( ( data, bdata ), a, b ) -> Bool -> ( ( ( data, Bool ), bdata ), a, b )
resMap ( ( a, b ), c, d ) e =
    ( ( ( a, e ), b ), c, d )


{-| Transform an IU component to user component.
-}
toConcreteUserComponent : ConcreteIUComponent cdata data userdata tar msg bdata scenemsg -> ConcreteUserComponent ( data, Bool ) cdata userdata tar msg bdata scenemsg
toConcreteUserComponent comp =
    let
        newInit runtime env msg =
            let
                ( newdata, newbdata ) =
                    comp.init runtime env msg
            in
            ( ( newdata, False ), newbdata )

        newUpdate runtime env evnt ( data, inited ) bdata =
            if inited then
                resMap (comp.update runtime env evnt data bdata) True

            else
                resMap (comp.initUpdate runtime env evnt data bdata) True

        newUpdateRec runtime env evnt ( data, inited ) bdata =
            resMap (comp.updaterec runtime env evnt data bdata) inited

        newView runtime env ( data, _ ) bdata =
            comp.view runtime env data bdata

        newMatcher ( data, _ ) bdata t =
            comp.matcher data bdata t
    in
    { init = newInit
    , update = newUpdate
    , updaterec = newUpdateRec
    , view = newView
    , matcher = newMatcher
    }


{-| Generate abstract IU component from concrete IU component.
-}
genIUComponent : ConcreteIUComponent cdata data userdata tar msg bdata scenemsg -> ComponentStorage cdata userdata tar msg bdata scenemsg
genIUComponent concomp =
    abstract <| toConcreteUserComponent concomp
