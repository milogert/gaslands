module View.Sponsor exposing (render, renderBadge, renderPerkClass)

import Html exposing (Html, a, b, div, h3, h6, input, label, li, p, span, text, ul)
import Html.Attributes exposing (attribute, checked, class, for, href, id, title, type_)
import Html.Events exposing (onCheck, onClick)
import Model.Model exposing (Msg(..))
import Model.Sponsors exposing (PerkClass, Sponsor, SponsorType, TeamPerk, VehiclePerk, fromPerkClass, fromSponsorType, getClassPerks, typeToSponsor)
import Model.Vehicles exposing (Vehicle)
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
            , onClick ToSponsorSelect
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
    div [ class "form-check" ]
        [ input
            [ class "form-check-input"
            , type_ "checkbox"
            , id perk.name
            , onCheck <| SetPerkInVehicle vehicle perk
            , checked <| List.member perk vehicle.perks
            ]
            []
        , label
            [ class "form-check-label"
            , for perk.name
            ]
            [ b [] [ text perk.name ]
            , text <| " (" ++ String.fromInt perk.cost ++ ") "
            , text perk.description
            ]
        ]
