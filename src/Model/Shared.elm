module Model.Shared exposing
    ( Category(..)
    , Size(..)
    , Special(..)
    , ammoInit
    , fromCategory
    , fromSpecial
    , getAmmoClip
    , needPlus
    , setCategory
    , specialToNamedSpecial
    )

import List.Extra as ListE


type Special
    = Ammo (List Bool)
    | SpecialRule String
    | NamedSpecialRule String String
    | Blast
    | BurstSpecial Size
    | Fire
    | Blitz
    | Electrical
    | HandlingMod Int
    | HullMod Int
    | GearMod Int
    | CrewMod Int
    | Indirect
    | Splash
    | FullFireArc


type Size
    = Small
    | Large


type Category
    = Basic
    | Advanced


ammoInit : Int -> Special
ammoInit clip =
    Ammo <| List.repeat clip False


stringFromSize : Size -> String
stringFromSize size =
    case size of
        Small ->
            "Small"

        Large ->
            "Large"


fromSpecial : Special -> String
fromSpecial special =
    case special of
        Ammo count ->
            "Ammo " ++ String.fromInt (List.length count)

        SpecialRule s ->
            "SpecialRule " ++ s

        NamedSpecialRule title desc ->
            "NamedSpecialRule " ++ title ++ " " ++ desc

        Blast ->
            "Blast"

        BurstSpecial size ->
            stringFromSize size ++ " Burst"

        Fire ->
            "Fire"

        Blitz ->
            "Blitz"

        Electrical ->
            "Electrical"

        HandlingMod i ->
            "HandlingMod " ++ String.fromInt i

        HullMod i ->
            "HullMod " ++ String.fromInt i

        GearMod i ->
            "GearMod " ++ String.fromInt i

        CrewMod i ->
            "CrewMod " ++ String.fromInt i

        Indirect ->
            "Indirect"

        Splash ->
            "Splash"

        FullFireArc ->
            "Full Fire Arc"


specialToNamedSpecial : Special -> Special
specialToNamedSpecial special =
    case special of
        Ammo count ->
            NamedSpecialRule "Ammo" (String.fromInt <| List.length count)

        SpecialRule rule ->
            NamedSpecialRule "Note" rule

        NamedSpecialRule name rule ->
            NamedSpecialRule name rule

        Blast ->
            NamedSpecialRule "Blast" "For every un-cancelled hit caused by a weapon or effect with the Blast rule, the target immediately gains 1 Hazard Token."

        Blitz ->
            NamedSpecialRule "Blitz" "This Vehicle counts as being armed with a number of copies of this weapon equal to this weapon's remaining Ammo Tokens, where each copy counts as having a single Ammo Token. this means that during its Attack Step, this vehicle may attack with this weapon any number of times, as long as it doesn't attack more times than it has Ammo Tokens, and doesn't attack more times than its Crew Value."

        BurstSpecial size ->
            NamedSpecialRule (stringFromSize size ++ " Burst") "TODO"

        Fire ->
            NamedSpecialRule "Fire" "If a vehicle suffers at least one damage from a weapon or effect with the first special rule, it gains the On-Fire rule in addition to suffering damage. A vehicle cannot gain the On-Fire rule a second time.\n\nOn Fire: At the start of this vehicle's activation, it loses 1 Hull Point. This vehile's Smash Attacks count as having the Fire special rule. If this vehicle ever has zero Hazard Tokens, the fire goes out and this vehicle loses the On-Fire rule."

        Electrical ->
            NamedSpecialRule "Electrical" "This thing is electrical."

        HandlingMod i ->
            NamedSpecialRule "Handling Mod"
                (needPlus i ++ " modification to the vehicle's base Handling value.")

        HullMod i ->
            NamedSpecialRule "Hull Mod"
                (needPlus i ++ " modification to the vehicle's base Hull value.")

        GearMod i ->
            NamedSpecialRule "Gear Mod"
                (needPlus i ++ " modification to the vehicle's maximum Gear.")

        CrewMod i ->
            NamedSpecialRule "Crew Mod"
                (needPlus i ++ " modification to the vehicle's base Crew value.")

        Indirect ->
            NamedSpecialRule "Indirect" "When making a shooting attack with a weapon with this special rule, the vehicle may ignore Terrain and Cover during that attack."

        Splash ->
            NamedSpecialRule "Splash" "When a weapon with the splash rule is used to attack, the weapon must target, and attack, every vehicle beneath the shooting template, including friendly vehicles. Each target must suffer a separate attack from the weapon."

        FullFireArc ->
            NamedSpecialRule "Full Fire Arc" "TODO"


getAmmoClip : List Special -> ( Maybe Int, Maybe Special )
getAmmoClip specials =
    let
        ammoFinder special =
            case special of
                Ammo _ ->
                    True

                _ ->
                    False

        mAmmoSpecial =
            ListE.find
                ammoFinder
                specials

        mAmmoSpecialIndex =
            ListE.findIndex
                ammoFinder
                specials
    in
    ( mAmmoSpecialIndex, mAmmoSpecial )


setCategory : Category -> { a | category : Category } -> { a | category : Category }
setCategory toSet thing =
    { thing | category = toSet }


fromCategory : Category -> String
fromCategory category =
    case category of
        Basic ->
            "Basic"

        Advanced ->
            "Advanced"


needPlus : Int -> String
needPlus i =
    case compare i 0 of
        LT ->
            String.fromInt i

        _ ->
            "+" ++ String.fromInt i
