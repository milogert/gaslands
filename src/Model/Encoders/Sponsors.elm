module Model.Encoders.Sponsors exposing (sponsorEncoder, vehiclePerkEncoder, sponsorTypeEncoder)

import Json.Encode exposing (..)
import Model.Sponsors exposing (..)


sponsorEncoder : Maybe Sponsor -> Value
sponsorEncoder msponsor =
    case msponsor of
        Nothing ->
            null

        Just sponsor ->
            object
                [ ( "name", string <| toString sponsor.name )
                , ( "description", string sponsor.description )
                , ( "perks", list <| List.map teamPerkEncoder sponsor.perks )
                , ( "grantedClasses", list <| List.map (\s -> s |> toString |> string) sponsor.grantedClasses )
                ]


sponsorTypeEncoder : SponsorType -> Value
sponsorTypeEncoder sponsorType =
    string <| toString sponsorType


teamPerkEncoder : TeamPerk -> Value
teamPerkEncoder perk =
    object
        [ ( "name", string perk.name )
        , ( "description", string perk.description )
        ]


vehiclePerkEncoder : VehiclePerk -> Value
vehiclePerkEncoder perk =
    object
        [ ( "name", string perk.name )
        , ( "cost", int perk.cost )
        , ( "description", string perk.description )
        ]
