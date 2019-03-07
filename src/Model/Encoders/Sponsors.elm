module Model.Encoders.Sponsors exposing (sponsorEncoder, vehiclePerkEncoder)

import Json.Encode exposing (..)
import Model.Encoders.Shared exposing (..)
import Model.Sponsors exposing (..)


sponsorEncoder : Maybe Sponsor -> Value
sponsorEncoder msponsor =
    case msponsor of
        Nothing ->
            null

        Just sponsor ->
            object
                [ ( "name", string sponsor.name )
                , ( "description", string sponsor.description )
                , ( "perks", list object <| List.map teamPerkEncoder sponsor.perks )
                , ( "grantedClasses", list string <| List.map (\s -> s |> fromPerkClass) sponsor.grantedClasses )
                , ( "expansion", object <| expansionEncoder sponsor.expansion )
                ]


teamPerkEncoder : TeamPerk -> List ( String, Value )
teamPerkEncoder perk =
    [ ( "name", string perk.name )
    , ( "description", string perk.description )
    ]


vehiclePerkEncoder : VehiclePerk -> List ( String, Value )
vehiclePerkEncoder perk =
    [ ( "name", string perk.name )
    , ( "cost", int perk.cost )
    , ( "description", string perk.description )
    ]
