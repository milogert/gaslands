module Model.Features exposing (flags, get, withDefault)

import Dict exposing (Dict)


flags : Dict String Bool
flags =
    Dict.fromList
        [ ( "feature-generate-team", False )
        ]


get : String -> a -> Maybe a
get feature actual =
    withDefault feature Nothing (Just actual)


withDefault : String -> a -> a -> a
withDefault feature default actual =
    case Dict.get feature flags of
        Nothing ->
            default

        Just onOff ->
            case onOff of
                True ->
                    actual

                False ->
                    default
