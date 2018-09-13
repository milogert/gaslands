module View.Sponsor exposing (render, renderBadge, renderPerkClass)

import Html exposing (Html, div, h3, h6, p, ul, text, span, li, b, a, input, label)
import Html.Attributes exposing (attribute, class, href, title, type_, id, for, checked)
import Html.Events exposing (onClick, onCheck)
import Model.Model exposing (Msg(..))
import Model.Vehicles exposing (Vehicle)
import Model.Sponsors exposing (Sponsor, TeamPerk, PerkClass, getClassPerks, VehiclePerk)
import View.Utils exposing (icon)


render : Sponsor -> Html Msg
render { name, description, perks, grantedClasses } =
    div []
        [ h3 [] [ name |> toString |> text ]
        , p [] [ text description ]
        , ul [] <| renderPerks perks
        , p [] <|
            (b [] [ text "Available Perk Classes: " ])
                :: (grantedClasses
                        |> List.map toString
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


renderBadge : Maybe Sponsor -> Html Msg
renderBadge ms =
    let
        ( name, description ) =
            case ms of
                Nothing ->
                    ( "No Sponsor", "" )

                Just s ->
                    ( s.name |> toString, s.description )
    in
        div [ class "sponsor-badge" ]
            [ span
                [ class "badge badge-secondary"
                , title description
                , attribute "data-toggle" "tooltip"
                , attribute "data-html" "true"
                ]
                [ text name ]
            , a
                [ onClick ToSponsorSelect
                , href "#"
                ]
                [ icon "exchange-alt" ]
            ]


renderPerkClass : Vehicle -> PerkClass -> Html Msg
renderPerkClass vehicle perkClass =
    div [] <|
        [ h6 [] [ text <| toString perkClass ] ]
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
            , text <| " (" ++ (toString perk.cost) ++ ") "
            , text perk.description
            ]
        ]
