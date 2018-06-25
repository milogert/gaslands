module Update.Utils exposing (addUpgrade, addVehicle, addWeapon, deleteVehicle, deleteWeapon, deleteUpgrade, setTmpVehicleType, setWeaponFired, updateActivated, updateGear, updateHazards, updateCrew, updateEquipment, updateHull, updateNotes, updateAmmoUsed, rollSkidDice, rollAttackDice, rollWeaponDie, import_, share, saveModel)

import Json.Encode
import Json.Decode
import Model.Decoders.Model exposing (modelDecoder)
import Model.Encoders.Model exposing (modelEncoder)
import Model.Model exposing (..)
import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)
import Model.Upgrades exposing (..)
import Ports.Ports
import Ports.Storage
import Random


(!!) : Int -> List a -> Maybe a
(!!) n xs =
    List.head <| List.drop n xs


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
                        { model | error = VehicleNameError :: model.error } ! []

                    ( _, _ ) ->
                        { model
                            | view = Overview
                            , vehicles = oldl ++ [ { vehicleTmp | id = List.length oldl } ]
                            , tmpVehicle = Nothing
                            , error = []
                        }
                            ! []

        Nothing ->
            model ! []


addWeapon : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
addWeapon model v w =
    let
        weaponList =
            v.weapons ++ [ { w | id = List.length v.weapons } ]

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        vehicleNew =
            { v | weapons = weaponList }

        newvehicles =
            pre ++ vehicleNew :: post
    in
        case ( w.wtype, w.mountPoint ) of
            ( _, Nothing ) ->
                { model | error = [ WeaponMountPointError ] } ! []

            ( _, _ ) ->
                { model | view = Details vehicleNew, error = [], vehicles = newvehicles } ! []


addUpgrade : Model -> Vehicle -> Upgrade -> ( Model, Cmd Msg )
addUpgrade model v u =
    let
        upgradeList =
            v.upgrades ++ [ { u | id = List.length v.upgrades } ]

        pre =
            List.take v.id model.vehicles

        post =
            List.drop (v.id + 1) model.vehicles

        vehicleNew =
            { v | upgrades = upgradeList }

        newvehicles =
            pre ++ vehicleNew :: post
    in
        { model
            | view = Details vehicleNew
            , error = []
            , vehicles = newvehicles
        }
            ! []


setTmpVehicleType : Model -> String -> ( Model, Cmd Msg )
setTmpVehicleType model vtstr =
    let
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

        newtv =
            Vehicle
                name
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
    in
        { model | tmpVehicle = Just newtv } ! []



{--[ Task.perform Dom.focus "nameInput" ]--}


updateActivated : Model -> Vehicle -> Bool -> ( Model, Cmd Msg )
updateActivated model v activated =
    let
        pre =
            List.take v.id model.vehicles

        nv =
            { v | activated = activated }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateGear : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateGear model v newGear =
    let
        newGearTracker =
            GearTracker newGear v.gear.max

        vehicleUpdated =
            { v | gear = newGearTracker }

        newView =
            case model.view of
                Details _ ->
                    Details vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = newView, vehicles = vehiclesList } ! []


updateHazards : Model -> Vehicle -> Int -> ( Model, Cmd Msg )
updateHazards model v newHazards =
    let
        vehicleUpdated =
            { v | hazards = newHazards }

        newView =
            case model.view of
                Details _ ->
                    Details vehicleUpdated

                _ ->
                    model.view

        vehiclesList =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = newView, vehicles = vehiclesList } ! []


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
                Details v ->
                    Details nv

                _ ->
                    model.view
    in
        { model | view = newView, vehicles = pre ++ nv :: post } ! []


updateCrew : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateCrew model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | crew = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateEquipment : Model -> Vehicle -> String -> ( Model, Cmd Msg )
updateEquipment model v strCurrent =
    let
        pre =
            List.take v.id model.vehicles

        current =
            String.toInt strCurrent |> Result.toMaybe |> Maybe.withDefault 0

        nv =
            { v | equipment = current }

        post =
            List.drop (v.id + 1) model.vehicles
    in
        { model | vehicles = pre ++ nv :: post } ! []


updateNotes : Model -> Bool -> Vehicle -> String -> ( Model, Cmd Msg )
updateNotes model isPreview v notes =
    case isPreview of
        True ->
            { model | tmpVehicle = Just { v | notes = notes } } ! []

        False ->
            let
                vehiclesNew =
                    joinAround v.id { v | notes = notes } model.vehicles
            in
                { model | vehicles = vehiclesNew } ! []


updateAmmoUsed : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
updateAmmoUsed model v w used =
    let
        weaponUpdated =
            { w | ammoUsed = used }

        weaponsNew =
            joinAround w.id weaponUpdated v.weapons |> correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


deleteVehicle : Model -> Vehicle -> ( Model, Cmd Msg )
deleteVehicle model v =
    let
        newvehicles =
            deleteFromList v.id model.vehicles |> correctIds
    in
        { model | view = Overview, vehicles = newvehicles } ! []


setWeaponFired : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
setWeaponFired model v w =
    let
        weaponUpdated =
            { w | status = WeaponFired }

        weaponsNew =
            joinAround w.id weaponUpdated v.weapons |> correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles

        minRoll =
            case weaponUpdated.attack of
                Just dice ->
                    dice.number

                Nothing ->
                    0

        maxRoll =
            case weaponUpdated.attack of
                Just dice ->
                    dice.number * dice.die

                Nothing ->
                    0
    in
        { model
            | view = Details vehicleUpdated
            , vehicles = vehiclesNew
        }
            ! [ Random.generate (RollWeaponDie v weaponUpdated) (Random.int minRoll maxRoll) ]


rollWeaponDie : Model -> Vehicle -> Weapon -> Int -> ( Model, Cmd Msg )
rollWeaponDie model v w result =
    let
        weaponUpdated =
            { w | attackRoll = result }

        vehicleUpdated =
            replaceWeaponInVehicle v weaponUpdated

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model
            | view = Details vehicleUpdated
            , vehicles = vehiclesNew
        }
            ! []


deleteWeapon : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
deleteWeapon model v w =
    let
        weaponsNew =
            deleteFromList w.id v.weapons |> correctIds

        vehicleUpdated =
            { v | weapons = weaponsNew }

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


deleteUpgrade : Model -> Vehicle -> Upgrade -> ( Model, Cmd Msg )
deleteUpgrade model v u =
    let
        upgradesNew =
            deleteFromList u.id v.upgrades |> correctIds

        vehicleUpdated =
            { v | upgrades = upgradesNew }

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


rollSkidDice : Model -> Vehicle -> List SkidResult -> ( Model, Cmd Msg )
rollSkidDice model v skidResults =
    let
        vehicleUpdated =
            { v | skidResults = skidResults }

        vehiclesNew =
            joinAround v.id vehicleUpdated model.vehicles
    in
        { model | view = Details vehicleUpdated, vehicles = vehiclesNew } ! []


rollAttackDice : Model -> Vehicle -> Weapon -> ( Model, Cmd Msg )
rollAttackDice model v w =
    model ! []


deleteFromList : Int -> List a -> List a
deleteFromList index list =
    (List.take index list) ++ (List.drop (index + 1) list)


correctIds : List { a | id : Int } -> List { a | id : Int }
correctIds xs =
    List.indexedMap (\i x -> { x | id = i }) xs


joinAround : Int -> a -> List a -> List a
joinAround i item xs =
    (List.take i xs) ++ item :: (List.drop (i + 1) xs)


getItem : Int -> List a -> Maybe a
getItem i xs =
    xs
        |> List.take i
        |> List.reverse
        |> List.head


replaceWeaponInVehicle : Vehicle -> Weapon -> Vehicle
replaceWeaponInVehicle v w =
    let
        weaponsNew =
            joinAround w.id w v.weapons |> correctIds
    in
        { v | weapons = weaponsNew }



-- IMPORT/EXPORT.


import_ : Model -> ( Model, Cmd Msg )
import_ model =
    let
        decodeRes =
            Json.Decode.decodeString modelDecoder model.importValue

        newModel : Model
        newModel =
            case decodeRes of
                Ok m ->
                    m

                Err s ->
                    { model | error = [ JsonDecodeError s ] }
    in
        { model
            | view = newModel.view
            , teamName = newModel.teamName
            , pointsAllowed = newModel.pointsAllowed
            , vehicles = newModel.vehicles
            , tmpVehicle = newModel.tmpVehicle
            , tmpWeapon = newModel.tmpWeapon
            , tmpUpgrade = newModel.tmpUpgrade
            , error = newModel.error
            , importValue = newModel.importValue
        }
            ! []


share : Model -> ( Model, Cmd Msg )
share model =
    let
        value =
            Json.Encode.encode 2 <| modelEncoder model
    in
        { model | importValue = value } ! [ Ports.Ports.share value ]



-- SAVING/LOADING.


saveModel : Model -> ( Model, Cmd Msg )
saveModel model =
    let
        storageKey =
            case model.teamName of
                Nothing ->
                    "NoName"

                Just str ->
                    str

        storageEntry =
            Ports.Storage.StorageEntry
                storageKey
                (Json.Encode.encode 2 <| modelEncoder model)
    in
        model ! [ Ports.Storage.set storageEntry ]
