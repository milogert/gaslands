module Update.Utils exposing (..)

import Model.Vehicles exposing (..)
import Model.Weapons exposing (..)


(!!) : Int -> List a -> Maybe a
(!!) n xs =
    List.head <| List.drop n xs


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
