module View.Sponsor exposing (render, renderBadge, renderPerkClass)

import Bootstrap.Form.Checkbox as Checkbox
import Html
    exposing
        ( Html
        , a
        , b
        , div
        , h3
        , h6
        , li
        , p
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( class
        , href
        , title
        )
import Html.Events exposing (onCheck, onClick)
import Model.Model exposing (..)
import Model.Sponsors
    exposing
        ( PerkClass
        , Sponsor
        , SponsorType
        , TeamPerk
        , VehiclePerk
        , fromPerkClass
        , fromSponsorType
        , getClassPerks
        , typeToSponsor
        )
import Model.Vehicles exposing (..)
import View.Utils exposing (icon)


render : Sponsor -> Html Msg
render { name, description, perks, grantedClasses } =
    div []
        [ h3 [] [ name |> fromSponsorType |> text ]
        , p [] [ text description ]
        , ul [] <| renderPerks perks
        , p [] <|
            b [] [ text "Available Perk Classes: " ]
                :: (grantedClasses
                        |> List.map fromPerkClass
                        |> List.intersperse ", "
                        |> List.map text
                   )
        ]


renderPerks : List TeamPerk -> List (Html Msg)
renderPerks ps =
    List.map
        (\p -> li [] [ renderTeamPerk p ])
        ps


renderTeamPerk : TeamPerk -> Html Msg
renderTeamPerk { name, description } =
    span []
        [ b [] [ text <| name ++ ": " ]
        , text description
        ]


renderBadge : Maybe SponsorType -> Html Msg
renderBadge ms =
    let
        ( name, description ) =
            case ms of
                Nothing ->
                    ( "No Sponsor", "" )

                Just sponsor ->
                    ( fromSponsorType sponsor, sponsor |> typeToSponsor |> .description )
    in
    span [ class "sponsor-badge" ]
        [ a
            [ class "badge badge-secondary"
            , onClick <| To ViewSelectingSponsor
            , href "#"
            , title description
            ]
            [ text name
            , icon "exchange-alt"
            ]
        ]


renderPerkClass : Vehicle -> PerkClass -> Html Msg
renderPerkClass vehicle perkClass =
    div [ class "col-md-6" ] <|
        [ h6 [] [ text <| fromPerkClass perkClass ] ]
            ++ (getClassPerks perkClass
                    |> List.map (renderVehiclePerk vehicle)
               )


renderVehiclePerk : Vehicle -> VehiclePerk -> Html Msg
renderVehiclePerk vehicle perk =
    Checkbox.checkbox
        [ Checkbox.id perk.name
        , Checkbox.onCheck <| VehicleMsg << SetPerkInVehicle vehicle perk
        , Checkbox.checked <| List.member perk vehicle.perks
        ]
    <|
        perk.name
            ++ " ("
            ++ String.fromInt perk.cost
            ++ ") "
            ++ perk.description
