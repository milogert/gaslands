module Update.Vehicle exposing (update)

import Model.Model exposing (..)
import Model.Sponsors exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Ports.Photo
import Update.Utils exposing (..)


update : Model -> VehicleEvent -> ( Model, Cmd Msg )
update model event =
    case event of
        AddVehicle ->
            addVehicle model

        DeleteVehicle v ->
            deleteVehicle model v

        NextGearPhase ->
            let
                weaponFunc =
                    \w -> { w | status = WeaponReady, attackRoll = 0 }

                vehicleFunc =
                    \v -> { v | weapons = v.weapons |> List.map weaponFunc }

                vs =
                    model.vehicles
                        |> List.map vehicleFunc
                        |> List.map (\v -> { v | activated = False })

                gearPhase =
                    if model.gearPhase < 6 then
                        model.gearPhase + 1

                    else
                        1
            in
            ( { model
                | view = ViewDashboard
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

        UpdateActivated v activated ->
            updateActivated model v activated

        UpdateGear v strCurrent ->
            updateGear model v (String.toInt strCurrent |> Maybe.withDefault 1)

        ShiftGear v mod min max ->
            updateGear model v <| clamp min max <| v.gear.current + mod

        UpdateHazards v strCurrent ->
            updateHazards model v (String.toInt strCurrent |> Maybe.withDefault 1)

        ShiftHazards v mod min max ->
            updateHazards model v <| clamp min max <| v.hazards + mod

        UpdateHull v strCurrent ->
            updateHull model v (String.toInt strCurrent |> Maybe.withDefault 1)

        ShiftHull v mod min max ->
            updateHull model v <| clamp min max <| v.hull.current + mod

        UpdateCrew v strCurrent ->
            updateCrew model v strCurrent

        UpdateEquipment v strCurrent ->
            updateEquipment model v strCurrent

        UpdateNotes v notes ->
            updateNotes model v notes

        SetPerkInVehicle vehicle perk isSet ->
            setPerkInVehicle model vehicle perk isSet

        GetStream v ->
            getStream model v

        TakePhoto v ->
            takePhoto model v

        SetPhotoUrlCallback url ->
            case model.view of
                ViewDetails vehicle ->
                    setUrlForVehicle model vehicle url

                _ ->
                    ( model, Cmd.none )

        DiscardPhoto vehicle ->
            discardPhoto model vehicle


addVehicle : Model -> ( Model, Cmd Msg )
addVehicle model =
    case model.tmpVehicle of
        Just vehicleTmp ->
            let
                oldl =
                    model.vehicles
            in
            case ( vehicleTmp.vtype, vehicleTmp.name ) of
                ( _, "" ) ->
                    ( { model | error = VehicleNameError :: model.error }
                    , Cmd.none
                    )

                ( _, _ ) ->
                    ( { model
                        | view = ViewDashboard
                        , vehicles = oldl ++ [ { vehicleTmp | id = List.length oldl } ]
                        , tmpVehicle = Nothing
                        , error = []
                      }
                    , doSaveModel
                    )

        Nothing ->
            ( model
            , Cmd.none
            )


setTmpVehicleType : Model -> Int -> ( Model, Cmd Msg )
setTmpVehicleType model index =
    let
        tailVehicles =
            List.drop (index + 1)

        name =
            case model.tmpVehicle of
                Just v ->
                    v.name

                Nothing ->
                    ""

        vtype =
            Maybe.withDefault Bike <| strToVT vtstr

        gear =
            GearTracker 1 (typeToGearMax vtype)

        handling =
            typeToHandling vtype

        hull =
            HullHolder 0 (typeToHullMax vtype)

        crew =
            typeToCrewMax vtype

        equipment =
            typeToEquipmentMax vtype

        weight =
            typeToWeight vtype

        weapons =
            case model.tmpVehicle of
                Just v ->
                    v.weapons

                Nothing ->
                    []

        upgrades =
            case model.tmpVehicle of
                Just v ->
                    v.upgrades

                Nothing ->
                    []

        notes =
            case model.tmpVehicle of
                Just v ->
                    v.notes

                Nothing ->
                    ""

        cost =
            typeToCost vtype

        specials =
            typeToSpecials vtype

        requiredSponsor =
            typeToSponsorReq vtype

        newtv =
            Vehicle
                name
                Nothing
                vtype
                gear
                0
                handling
                []
                hull
                crew
                equipment
                weight
                False
                weapons
                upgrades
                notes
                cost
                -1
                specials
                []
                requiredSponsor
    in
    ( { model | tmpVehicle = Just newtv }
    , Cmd.none
    )


updateActivated : Model -> Vehicle -> Bool -> ( Model, Cmd Msg )
updateActivated model v activated =
    let
        pre =
            List.take v.id model.vehicles

        nv =
            { v | activated = activated }

        post =
            List.drop (v.id + 1) model.vehicles

        newView =
            case model.view of
                ViewDetails currentVehicle ->
                    ViewDetails nv

                _ ->
                    model.view
    in
    ( { model | view = newView, vehicles = pre ++ nv :: post }
    , Cmd.none
    )


updateGear : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateGear model v newGear =
    let
        newGearTracker =
            GearTracker newGear v.gear.max

        vehicleUpdated =
            { v | gear = newGearTracker }

        newView =
            case model.view of
                ViewDetails _ ->
                    ViewDetails vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = newView, vehicles = vehiclesList }
    , Cmd.none
    )


updateHazards : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateHazards model v newHazards =
    let
        vehicleUpdated =
            { v | hazards = newHazards }

        newView =
            case model.view of
                ViewDetails _ ->
                    ViewDetails vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = newView, vehicles = vehiclesList }
    , Cmd.none
    )


updateHull : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateHull model v currentHull =
    let
        pre =
            List.take v.id model.vehicles

        nhull =
            v.hull

        nv =
            { v | hull = { nhull | current = currentHull } }

        post =
            List.drop (v.id + 1) model.vehicles

        newView =
            case model.view of
                ViewDetails _ ->
                    ViewDetails nv

                _ ->
                    model.view
    in
    ( { model | view = newView, vehicles = pre ++ nv :: post }
    , Cmd.none
    )


updateCrew : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateCrew model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Maybe.withDefault 0

        nv =
            { v | crew = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
    ( { model | vehicles = pre ++ nv :: post }
    , Cmd.none
    )


updateEquipment : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateEquipment model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Maybe.withDefault 0

        nv =
            { v | equipment = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
    ( { model | vehicles = pre ++ nv :: post }
    , Cmd.none
    )


updateNotes : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateNotes model v notes =
    let
        vehiclesNew =
            Update.Utils.replaceAtIndex v.id { v | notes = notes } model.vehicles
    in
    ( { model | vehicles = vehiclesNew }
    , Cmd.none
    )


updateAmmoUsed : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
updateAmmoUsed model v w used =
    let
        weaponUpdated =
            { w | ammoUsed = used }

        weaponsNew =
            Update.Utils.replaceAtIndex w.id weaponUpdated v.weapons |> Update.Utils.correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = ViewDetails vehicleUpdated, vehicles = vehiclesNew }
    , Cmd.none
    )


deleteVehicle : Model -> Vehicle -> ( Model, Cmd Msg )
deleteVehicle model v =
    let
        newvehicles =
            Update.Utils.deleteFromList v.id model.vehicles |> Update.Utils.correctIds
    in
    ( { model | view = ViewDashboard, vehicles = newvehicles }
    , Cmd.none
    )


rollSkidDice : Model -> Vehicle -> List SkidResult -> ( Model, Cmd Msg )
rollSkidDice model v skidResults =
    let
        vehicleUpdated =
            { v | skidResults = skidResults }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = ViewDetails vehicleUpdated, vehicles = vehiclesNew }
    , Cmd.none
    )


replaceWeaponInVehicle : Vehicle -> Weapon -> Vehicle
replaceWeaponInVehicle v w =
    let
        weaponsNew =
            Update.Utils.replaceAtIndex w.id w v.weapons |> Update.Utils.correctIds
    in
    { v | weapons = weaponsNew }


setPerkInVehicle : Model -> Vehicle -> VehiclePerk -> Bool -> ( Model, Cmd Msg )
setPerkInVehicle model v perk isSet =
    let
        perkList =
            case ( isSet, List.member perk v.perks ) of
                ( True, False ) ->
                    perk :: v.perks

                ( False, _ ) ->
                    List.filter (\s -> s /= perk) v.perks

                _ ->
                    v.perks

        vehicleUpdated =
            { v | perks = perkList }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = ViewDetails vehicleUpdated, vehicles = vehiclesNew }
    , Cmd.none
    )


getStream : Model -> Vehicle -> ( Model, Cmd Msg )
getStream model v =
    ( model
    , Ports.Photo.getStream ""
    )


takePhoto : Model -> Vehicle -> ( Model, Cmd Msg )
takePhoto model v =
    ( model
    , Ports.Photo.takePhoto ""
    )


setUrlForVehicle : Model -> Vehicle -> String -> ( Model, Cmd Msg )
setUrlForVehicle model v url =
    let
        vehicleUpdated =
            { v | photo = Just url }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = ViewDetails vehicleUpdated, vehicles = vehiclesNew }
    , Ports.Photo.destroyStream ""
    )


discardPhoto : Model -> Vehicle -> ( Model, Cmd Msg )
discardPhoto model v =
    let
        vehicleUpdated =
            { v | photo = Nothing }

        vehiclesNew =
            Update.Utils.replaceAtIndex v.id vehicleUpdated model.vehicles
    in
    ( { model | view = ViewDetails vehicleUpdated, vehicles = vehiclesNew }
    , Ports.Photo.getStream ""
    )
