module View.Sponsor exposing
    ( render
    , renderBadge
    , renderPerkClass
    , renderPerkList
    )

import Bulma.Columns exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Form exposing (..)
import Bulma.Modifiers exposing (..)
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Solid as Icon
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
        , small
        , span
        , text
        , ul
        )
import Html.Attributes
    exposing
        ( checked
        , class
        , href
        , id
        )
import Html.Events exposing (onCheck, onClick)
import Model.Model exposing (..)
import Model.Shared exposing (fromExpansion)
import Model.Sponsors
    exposing
        ( PerkClass
        , Sponsor
        , TeamPerk
        , VehiclePerk
        , fromPerkClass
        , getClassPerks
        )
import Model.Vehicle.Model exposing (..)
import View.Utils exposing (expansionMarker)


render : Sponsor -> Html Msg
render { name, description, perks, grantedClasses, expansion } =
    div []
        [ title H5 [] [ text name ]
        , p [] [ text description ]
        , ul [] <| renderPerks perks
        , p [] <|
            b [] [ text "Available Perk Classes: " ]
                :: (grantedClasses
                        |> List.map fromPerkClass
                        |> List.intersperse ", "
                        |> List.map text
                   )
        , expansionMarker expansion
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

                Just sponsor ->
                    ( sponsor.name, sponsor.description )
    in
    button
        { buttonModifiers
            | size = Small
            , iconRight = Just ( Small, [], Icon.exchangeAlt |> Icon.viewIcon )
        }
        [ href "/sponsor"
        , Html.Attributes.title description
        ]
        [ text name ]


renderPerkClass : Vehicle -> PerkClass -> Html Msg
renderPerkClass vehicle perkClass =
    column columnModifiers
        []
        ([ title H6 [] [ text <| fromPerkClass perkClass ] ]
            ++ (perkClass
                    |> getClassPerks
                    |> List.map (renderVehiclePerk vehicle)
               )
        )


renderPerkList : List VehiclePerk -> List PerkClass -> Html Msg
renderPerkList perks perkClasses =
    perkClasses
        |> List.map
            (\perkClass ->
                perkClass
                    |> getClassPerks
                    |> List.filter
                        (\perk -> List.member perk perks)
                    |> List.map printPerk
            )
        |> List.map (\t -> p [] t)
        |> div []


renderVehiclePerk : Vehicle -> VehiclePerk -> Html Msg
renderVehiclePerk vehicle perk =
    controlCheckBox
        False
        []
        []
        [ id perk.name
        , onCheck <| VehicleMsg << SetPerkInVehicle vehicle.key perk
        , checked <| List.member perk vehicle.perks
        ]
        [ printPerk perk ]


printPerk : VehiclePerk -> Html Msg
printPerk perk =
    span []
        [ b []
            [ text <|
                perk.name
                    ++ " ("
                    ++ String.fromInt perk.cost
                    ++ "): "
            ]
        , text perk.description
        ]
