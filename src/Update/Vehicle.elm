module Update.Vehicle exposing (update)

import Dict exposing (Dict)
import List.Extra as ListE
import Model.Model exposing (..)
import Model.Routes exposing (Route(..))
import Model.Sponsors exposing (..)
import Model.Vehicle.Common exposing (..)
import Model.Vehicle.Model exposing (..)
import Model.Weapon.Model exposing (..)
import Ports.Photo
import Update.Utils exposing (..)
import View.Utils


update : Model -> VehicleEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        AddVehicle vehicle ->
            addVehicle model vehicle

        DeleteVehicle key ->
            deleteVehicle model key

        NextGearPhase ->
            let
                weaponFunc =
                    \w -> { w | status = WeaponReady, attackRoll = 0 }

                vehicleFunc =
                    \k v -> { v | weapons = v.weapons |> List.map weaponFunc }

                vs =
                    model.vehicles
                        |> Dict.map vehicleFunc
                        |> Dict.map (\k v -> { v | activated = False })

                gearPhase =
                    case compare model.gearPhase 6 of
                        LT ->
                            model.gearPhase + 1

                        _ ->
                            1
            in
            ( { model
                | view = RouteDashboard
                , gearPhase = gearPhase
                , vehicles = vs
              }
            , Cmd.none
            )

        TmpName name ->
            case model.tmpVehicle of
                Just v ->
                    ( { model | tmpVehicle = Just { v | name = name } }
                    , Cmd.none
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    )

        TmpVehicleType indexString ->
            case indexString of
                "-1" ->
                    ( { model | tmpVehicle = Nothing }, Cmd.none )

                _ ->
                    setTmpVehicleType model (Maybe.withDefault 0 (String.toInt indexString))

        TmpNotes notes ->
            case model.tmpVehicle of
                Just v ->
                    ( { model | tmpVehicle = Just { v | notes = notes } }
                    , Cmd.none
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    )

        UpdateActivated key activated ->
            updateActivated model key activated

        UpdateGear key strCurrent ->
            updateGear model key (String.toInt strCurrent |> Maybe.withDefault 1)

        ShiftGear key mod min max ->
            case Dict.get key model.vehicles of
                Nothing ->
                    ( model, Cmd.none )

                Just vehicle ->
                    updateGear model key <| clamp min max <| vehicle.gear.current + mod

        UpdateHazards v strCurrent ->
            String.toInt strCurrent
                |> Maybe.withDefault 1
                |> updateHazards model v

        ShiftHazards key mod min max ->
            case Dict.get key model.vehicles of
                Nothing ->
                    ( model, Cmd.none )

                Just vehicle ->
                    vehicle.hazards
                        + mod
                        |> clamp min max
                        |> updateHazards model key

        UpdateHull v strCurrent ->
            String.toInt strCurrent
                |> Maybe.withDefault 1
                |> updateHull model v

        ShiftHull key mod min max ->
            case Dict.get key model.vehicles of
                Nothing ->
                    ( model, Cmd.none )

                Just vehicle ->
                    vehicle.hull.current
                        + mod
                        |> clamp min max
                        |> updateHull model key

        UpdateCrew vkey strCurrent ->
            updateCrew model vkey strCurrent

        UpdateEquipment vkey strCurrent ->
            updateEquipment model vkey strCurrent

        UpdateNotes key notes ->
            updateNotes model key notes

        SetPerkInVehicle vehicle perk isSet ->
            setPerkInVehicle model vehicle perk isSet

        GetStream key ->
            getStream model key

        TakePhoto key ->
            takePhoto model key

        SetPhotoUrlCallback url ->
            case model.view of
                RouteDetails key ->
                    setUrlForVehicle model key url

                _ ->
                    ( model, Cmd.none )

        DiscardPhoto vehicle ->
            discardPhoto model vehicle


addVehicle : Model -> Vehicle -> ( Model, Cmd Msg )
addVehicle model vehicle =
    let
        key =
            vehicle.name ++ String.fromInt (Dict.size model.vehicles)

        newDict =
            Dict.insert
                key
                { vehicle | key = key }
                model.vehicles
    in
    case ( vehicle.vtype, vehicle.name ) of
        ( _, "" ) ->
            ( { model | error = VehicleNameError :: model.error }
            , Cmd.none
            )

        ( _, _ ) ->
            ( { model
                | view = RouteDashboard
                , vehicles = newDict
                , tmpVehicle = Nothing
                , error = []
              }
            , Cmd.batch [ doSaveModel, doCloseModal "vehicle" ]
            )


setTmpVehicleType : Model -> Int -> ( Model, Cmd Msg )
setTmpVehicleType model index =
    ( { model
        | tmpVehicle =
            allVehicles
                |> List.filter (View.Utils.vehicleSponsorFilter model)
                |> ListE.getAt index
      }
    , Cmd.none
    )


updateActivated : Model -> String -> Bool -> ( Model, Cmd Msg )
updateActivated model key activated =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle | activated = activated }

                newView =
                    case model.view of
                        RouteDetails currentVehicle ->
                            RouteDetails nv.key

                        _ ->
                            model.view
            in
            ( { model
                | view = newView
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


updateGear : Model -> String -> Int -> ( Model, Cmd Msg )
updateGear model key newGear =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle
                        | gear = GearTracker newGear vehicle.gear.max
                    }

                newView =
                    case model.view of
                        RouteDetails _ ->
                            RouteDetails nv.key

                        _ ->
                            model.view
            in
            ( { model | view = newView, vehicles = Dict.insert key nv model.vehicles }
            , Cmd.none
            )


updateHazards : Model -> String -> Int -> ( Model, Cmd Msg )
updateHazards model key newHazards =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle | hazards = newHazards }

                newView =
                    case model.view of
                        RouteDetails _ ->
                            RouteDetails nv.key

                        _ ->
                            model.view
            in
            ( { model
                | view = newView
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


updateHull : Model -> String -> Int -> ( Model, Cmd Msg )
updateHull model key currentHull =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nhull =
                    vehicle.hull

                nv =
                    { vehicle | hull = { nhull | current = currentHull } }

                newView =
                    case model.view of
                        RouteDetails _ ->
                            RouteDetails nv.key

                        _ ->
                            model.view
            in
            ( { model
                | view = newView
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


updateCrew : Model -> String -> String -> ( Model, Cmd Msg )
updateCrew model key strCurrent =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                current =
                    String.toInt strCurrent |> Maybe.withDefault 0

                nv =
                    { vehicle | crew = current }
            in
            ( { model | vehicles = Dict.insert key nv model.vehicles }
            , Cmd.none
            )


updateEquipment : Model -> String -> String -> ( Model, Cmd Msg )
updateEquipment model key strCurrent =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                current =
                    String.toInt strCurrent |> Maybe.withDefault 0

                nv =
                    { vehicle | equipment = current }
            in
            ( { model | vehicles = Dict.insert key nv model.vehicles }
            , Cmd.none
            )


updateNotes : Model -> String -> String -> ( Model, Cmd Msg )
updateNotes model key notes =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                newVehicle =
                    { vehicle | notes = notes }
            in
            ( { model
                | vehicles = Dict.insert key newVehicle model.vehicles
                , view = RouteDetails newVehicle.key
              }
            , Cmd.none
            )


deleteVehicle : Model -> String -> ( Model, Cmd Msg )
deleteVehicle model key =
    ( { model
        | view = RouteDashboard
        , vehicles = Dict.remove key model.vehicles
      }
    , Cmd.none
    )


rollSkidDice : Model -> String -> List SkidResult -> ( Model, Cmd Msg )
rollSkidDice model key skidResults =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle | skidResults = skidResults }
            in
            ( { model
                | view = RouteDetails nv.key
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


setPerkInVehicle : Model -> String -> VehiclePerk -> Bool -> ( Model, Cmd Msg )
setPerkInVehicle model key perk isSet =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                perkList =
                    case ( isSet, List.member perk vehicle.perks ) of
                        ( True, False ) ->
                            perk :: vehicle.perks

                        ( False, _ ) ->
                            List.filter (\s -> s /= perk) vehicle.perks

                        _ ->
                            vehicle.perks

                nv =
                    { vehicle | perks = perkList }
            in
            ( { model
                | view = RouteDetails nv.key
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Cmd.none
            )


getStream : Model -> String -> ( Model, Cmd Msg )
getStream model key =
    ( model
    , Ports.Photo.getStream ""
    )


takePhoto : Model -> String -> ( Model, Cmd Msg )
takePhoto model key =
    ( model
    , Ports.Photo.takePhoto ""
    )


setUrlForVehicle : Model -> String -> String -> ( Model, Cmd Msg )
setUrlForVehicle model key url =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle | photo = Just url }
            in
            ( { model
                | view = RouteDetails nv.key
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Ports.Photo.destroyStream ""
            )


discardPhoto : Model -> String -> ( Model, Cmd Msg )
discardPhoto model key =
    case Dict.get key model.vehicles of
        Nothing ->
            ( model, Cmd.none )

        Just vehicle ->
            let
                nv =
                    { vehicle | photo = Nothing }
            in
            ( { model
                | view = RouteDetails nv.key
                , vehicles = Dict.insert key nv model.vehicles
              }
            , Ports.Photo.getStream ""
            )
