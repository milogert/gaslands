module Model.Sponsors exposing (..)


type alias Sponsor =
    { name : SponsorType
    , description : String
    , perks : List TeamPerk
    , grantedClasses : List PerkClass
    }


type SponsorType
    = Rutherford
    | Miyazaki
    | Mishkin
    | Idris
    | Slime
    | Warden


type PerkClass
    = Aggression
    | Badass
    | Daring
    | Military
    | Precision
    | Speed
    | Technology
    | PrisonCars


type alias TeamPerk =
    { name : String
    , description : String
    }


type alias VehiclePerk =
    { name : String
    , cost : Int
    , description : String
    }


allSponsors : List Sponsor
allSponsors =
    [ rutherford
    , miyazaki
    , mishkin
    , idris
    , slime
    , warden
    ]


getClassPerks : PerkClass -> List VehiclePerk
getClassPerks perkClass =
    case perkClass of
        Aggression ->
            aggression

        Badass ->
            badass

        Daring ->
            daring

        Military ->
            military

        Precision ->
            precision

        Speed ->
            speed

        Technology ->
            technology

        PrisonCars ->
            prisonCars


typeToSponsor : SponsorType -> Sponsor
typeToSponsor type_ =
    case type_ of
        Rutherford ->
            rutherford

        Miyazaki ->
            miyazaki

        Mishkin ->
            mishkin

        Idris ->
            idris

        Slime ->
            slime

        Warden ->
            warden


stringToSponsor : String -> Maybe Sponsor
stringToSponsor str =
    case str of
        "Rutherford" ->
            Just rutherford

        "Miyazaki" ->
            Just miyazaki

        "Mishkin" ->
            Just mishkin

        "Idris" ->
            Just idris

        "Slime" ->
            Just slime

        "Warden" ->
            Just warden

        _ ->
            Nothing



-- SPONSORS.


rutherford : Sponsor
rutherford =
    Sponsor
        Rutherford
        "Grant Rutherford is the son of a militaristic American oil baron. He is aggressive, rich and uncompromising. His beaming face, beneath his trademark cream Stetson, adorns billboard advertisements for his high-quality and high-priced Rutherford brand weaponry. Teams sponsored by Rutherford get access to military surplus, missile launchers, tanks and helicopters and as much ammo as they can carry. After his team won in 2016, he was only too happy to kiss the Earth goodbye and now runs his company from his highly exclusive Martian office."
        [ TeamPerk "Military Hardware"
            "This team may purchase a single Tank. This team may purchase a single Helicopter."
        , TeamPerk "Well Stocked"
            "This team considers any weapon with the ammo 3 special rule to instead have the ammo 4 special rule when purchased."
        , TeamPerk "Might Is Right"
            "This team may not purchase lightweight vehicles."
        , TeamPerk "Televised Carnage"
            "If a vehicle in this team causes 6 or more hits in a single attack step, before evades, this team gains +1 audience votes."
        ]
        [ Badass, Military ]


miyazaki : Sponsor
miyazaki =
    Sponsor
        Miyazaki
        "Yuri Miyazaki grew up in the rubble of Tokyo, fighting her way to the top of the speedway circuit with incredible feats of daring and vehicular agility. She has a small fleet of elite couriers who run jobs for the wealthiest or most desperate clients. It is whispered that she also runs guns for the Pro-Earth Resistance, but no one who spreads that rumour lives long enough to spread it far. Miyazaki's drivers are unsurpassed in their skill and finesse."
        [ TeamPerk "Virtuoso"
            "The first time each vehicle in this team uses push it in an activation they may push it without gaining a hazard token."
        , TeamPerk "Evasive Maneuvers"
            "Before making an evade roll, vehicles in this team may gain any number of hazard tokens to add +1 to each of their evade dice for each hazard token gained. A roll of \"1\" on an evade dice always counts as a failure."
        , TeamPerk "Elegance"
            "Teams sponsored by Miyazaki may not purchase Pickup Trucks, Buses or War Rigs."
        , TeamPerk "Showing Off"
            "Once per gear phase, if all of this team's in-play vehicles activated, resolved at least on un-canceled spin result, resolved at least one un-canceled slide result, resolved at least on stick-shift, and did not wipe out, this team gains +1 audience vote for each of this team's in-play vehicles."
        ]
        [ Daring, Precision ]


mishkin : Sponsor
mishkin =
    Sponsor
        Mishkin
        "Andre Mishkin is not a natural sportsman. However, the brilliant Russian engineer and inventor proves in 2010 that technology is just as solid an answer as skill or ferocity on the track. From his research and development facility on Mars he continues to send designs for unusual and devastating weapons and sleep, hi-tech vehicles to Earth for field-testing by the teams he sponsors."
        [ TeamPerk "Thumpermonkey"
            "This team may purchase electrical weapons and upgrades."
        , TeamPerk "Dynamo"
            "After activating in gear Phase 4, 5 or 6, this vehicle may add +1 ammo tokens to a single electrical weapon or upgrade on that vehicle."
        , TeamPerk "All the Toys"
            "Whenever a vehicle in this team attack with a named weapon that has not been attacked with by any vehicle during this game yet this team gains +1 audience vote."
        ]
        [ Military, Technology ]


idris : Sponsor
idris =
    Sponsor
        Idris
        "Yandi Idris is an addict. From the first time the hot and sweet fumes of a singing petrol engine filled his nose he could find no other joy. He said that the first time he pressed that nitro-oxide button was like touching the face of God. Mystical, irrational and dangerous, the Cult of Speed spread like wildfire after Idris' meteoric rise during the 2012 Gaslands season. He crossed the final finishing line in a ball of fire and his body was never found. His fanatical followers say that at 201mph you can hear his sonorous voice on the rushing head wind."
        [ TeamPerk "N2O Addict"
            "This team may purchase the Nitro upgrade at half the listed cost."
        , TeamPerk "Speed Demon"
            "When using Nitro, vehicles in this team only gain hazard tokens until they have 3 hazard tokens after each of the two activation, rather than the normal 5."
        , TeamPerk "Cult of Speed"
            "If a vehicle in this team selects the long straight maneuver template in movement step 1.1 during gear phase 1, 2 or 3, this team gains +1 audience vote."
        , TeamPerk "Kiss My Asphalt"
            "This team may not purchase Gyrocopters."
        ]
        [ Precision, Speed ]


slime : Sponsor
slime =
    Sponsor
        Slime
        "Slime rules a wild and feral city in the Australian wastes known as Anarchy. Young people crawled out of the wreckage of the scorched earth in their thousands to rally round her ragged banner. The wild-eyed and whooping joyful gangs of Anarchy are led by Slime's henchwomen, the Chooks, who seek fame and adoration from the global Gaslands audience."
        [ TeamPerk "Live Fast"
            "If a vehicle in this tam begins the wipeout step with more hazard tokens than hull points during its own activation this team gains +1 audience vote."
        , TeamPerk "Pinball"
            "If a vehicle in this team is involved in a sideswipe smash attack during its activation, immediately resolve another movement step with that vehicle after the current movement step."
        ]
        [ Aggression, Speed ]


warden : Sponsor
warden =
    Sponsor
        Warden
        "Warden Cadeila is proud to live in Sao Paulo, a shining hub of humanity and relatively untouched by the war. The Sao Paulo People's Penitentiary has three of Gaslands' top ten teams in the past decade, and the Warden continues to grant her prisoners a chance at freedom as long as the Gaslands franchise continues to deliver the sponsorship deals. The deal isn't great from the damned souls who are welded into the Warden's solid steel \"coffin cars\", but it's better than the alternative."
        [ TeamPerk "Prison Cars"
            "Vehicles in this team may purchase the Prison Cars upgrade."
        , TeamPerk "Fireworks"
            "If a vehicle belonging to this team explodes, gain +1 audience vote if it was middleweight or +2 audience votes if it was heavyweight in addition to any votes gained for being wrecked, and then discard all ammo tokens from the wreck."
        ]
        [ Aggression, Badass, PrisonCars ]



-- PERK CLASS PERKS.


aggression : List VehiclePerk
aggression =
    [ VehiclePerk "Double-Barreled" 2 "During the attack step, up to 3 crewmembers in this vehicle may gain a +1 bonus to hit when shooting with a handgun."
    , VehiclePerk "Boarding Party" 2 "This vehicle ignores the distracted rule. Crewmembers in this vehicle may attack during the attack step even if the vehicle is distracted."
    , VehiclePerk "Battlehammer" 4 "When making a smash attack, this vehicle gains +1 attack dice for each hazard token it currently has."
    , VehiclePerk "Terrifying Lunatic" 5 "Whenever a vehicle controlled by another player ends its movement step within short range of this vehicle, the active vehicle gains a hazard token."
    , VehiclePerk "Grinderman" 5 "Before this vehicle rolls its attack dice in a smash attack, it may choose to add hazard tokens to the target vehicle for each damage it inflicts, instead of removing hull points."
    , VehiclePerk "Murder Tractor" 5 "This vehicle may make piledriver attacks, like a War Rig."
    ]


badass : List VehiclePerk
badass =
    [ VehiclePerk "Powder Keg" 1 "This vehicle may add +1 to its explosion check. Treat this vehicle as one weight-class heavier when it explodes. NOTE: this bonus does apply during resolution of the FIREWORKS perk."
    , VehiclePerk "Road Warrior" 2 "If this vehicle successfully causes one or more hits on an enemy vehicle at any point during its activation, this vehicle may remove a single hazard token for free at the end of its activation."
    , VehiclePerk "Cover Me" 2 "Once during its activation, this vehicle may remove a hazard token and place it on anther friendly vehicle within double range."
    , VehiclePerk "Fist of Steel" 4 "This vehicle may take a hazard token to re-roll all its attack dice during a smash attack."
    , VehiclePerk "Madman" 3 "At the end of this vehicle's activation, if it has 4 or more hazard tokens, it may remove a hazard token and place it on another vehicle within medium range."
    , VehiclePerk "Crowd Pleaser" 1 "If this vehicle wipes out, gain +1 audience vote."
    ]


daring : List VehiclePerk
daring =
    [ VehiclePerk "Evasive" 5 "This vehicle counts a roll of a 5+ as a success during an evade attempt."
    , VehiclePerk "Powerslide" 5 "This vehicle may use any template except the long straight template instead of the slide template when applying a slide result. As with the movement step 1.1, you must use the first maneuver template you touch. Treat the selected maneuver template as a slide template for purposes of finding the vehicle's final position."
    , VehiclePerk "Slippery" 3 "Vehicles making a smash attack targeting this vehicle suffer a penalty of -2 attack dice."
    , VehiclePerk "Trick Driving" 5 "This vehicle may select a maneuver template as if its current gear was on higher or one lower. This vehicle still uses its actual current gear during its skid check. An otherwise unpermitted maneuver template selected using this perk counts as a hazardous maneuver."
    , VehiclePerk "Stunt Driver" 7 "May only be taken on a Bike, Buggy, Car or Performance Car. This vehicle may choose to ignore any number of obstructions during its movement step. After any movement step in which this vehicle chooses to ignore any obstruction using this ability, this vehicle immediately gains 3 hazard tokens."
    , VehiclePerk "Chrome-Whisperer" 2 "This vehicle may push it any number of times during a single skid check, gaining +1 hazard token each time."
    ]


military : List VehiclePerk
military =
    [ VehiclePerk "Return Fire" 5 "Once per gear phase, if this vehicle is the target of a shooting attack, this vehicle may take 2 hazard tokens to immediately attack, as if it was the vehicle's attack step."
    , VehiclePerk "Dead-Eye" 3 "During this vehicle's attack step, up to three crewmembers in this vehicle may gain a +1 bonus to hit if making a shooting attack at a target within double range and not within medium range. Critical hits still occur only on the natural roll of a 6."
    , VehiclePerk "Rapid Fire" 2 "Once per turn a single crewmember in this vehicle may shoot twice with the same weapon in a single attack step. When firing a weapon that has limited ammo in this way, each attack removes a separate ammo token."
    , VehiclePerk "Headshot" 4 "When making a shooting attack, this vehicle's critical hits inflict 3 hits instead of the normal 2 hits."
    , VehiclePerk "Loader" 2 "This vehicle may assign two crewmembers to a single weapon during the attack step to gain +1 to hit with that weapon. The second crewmember may not make a separate attack. Critical hits still occur only on the natural roll of a 6."
    , VehiclePerk "Fully Loaded" 2 "When this vehicle attacks with a shooting weapon that has 2 or more ammo tokens remaining, gain +1 attack die."
    ]


precision : List VehiclePerk
precision =
    [ VehiclePerk "Big Tires" 2 "This vehicle may ignore the penalties for being on rough or treacherous surfaces."
    , VehiclePerk "Moment of Glory" 5 "Once per game, after rolling the skid dice, but before resolving the results, this vehicle may immediately change any number of skid dice to any results they choose."
    , VehiclePerk "Easy Rider" 2 "Once per turn, this vehicle may discard one rolled skid die result before applying the results."
    , VehiclePerk "Restraint" 2 "When making a skid check, this vehicle does not receive hazard tokens for stick-shifting down a gear."
    , VehiclePerk "Expertise" 3 "This vehicle adds +1 to its handling value."
    , VehiclePerk "Handbrake Artist" 5 "When applying a spin result, this vehicle may choose to face any direction."
    ]


speed : List VehiclePerk
speed =
    [ VehiclePerk "Hot Start" 1 "Roll a D6 at the start of the game. This vehicle starts the game in that gear."
    , VehiclePerk "Slipstream" 2 "During this vehicles' skid check, this vehicle gains a shift result if there is another vehicle within short range in front of it, (measured like a front-mounted short range shooting attack)."
    , VehiclePerk "Force Transferal" 2 "If this vehicle loses one or more hull points due to any attack with the Blast rule, this vehicle may immediately stick-shift up."
    , VehiclePerk "Overload" 2 "When making a skid check, this vehicle may roll one additional skid die. If it does, it must change up at least one gear or gain a hazard token."
    , VehiclePerk "Time Extended!" 3 "At the end of an activation in which this vehicle passes a gate, before checking for wipeouts, this vehicle may immediately remove any number of hazard tokens."
    , VehiclePerk "Hell For Leather" 5 "This vehicle considers long straight to be permitted in any gear. The long straight is not considered either hazardous or trivial in any gear."
    ]


technology : List VehiclePerk
technology =
    [ VehiclePerk "Rocket Thrusters" 1 "When this vehicle is moved as part of a flip, it may choose to use the long straight, veer or gentle templates instead of the medium straight template."
    , VehiclePerk "Whizbang" 1 "At the start of each game, this vehicle gains a random SPEED PERK. This perk is lost at the end of the game."
    , VehiclePerk "Gyroscope" 1 "At the start of each game, this vehicle gains a random PRECISION PERK. This perk is lost at the end of the game."
    , VehiclePerk "Mobile Mechanic" 5 "Once per turn, during the attack step, a single crewmember may be assigned to perform a FIELD REPAIR instead of attack with a weapon. This vehicle gains 1 hull point, which may not take the remaining hull points above the vehicle's hull value."
    , VehiclePerk "Experimental Nuclear Engine" 5 "Add +2 to this vehicle's max gear, (up to a maximum of 6). This vehicle considers the long straight maneuver to be permitted in any gear. If this vehicle ever fails a flip check, it is immediately wrecked and explodes. When this vehicle explodes, it counts as heavyweight. This per may not be purchased for lightweight vehicles."
    , VehiclePerk "Experimental Teleporter" 7 "At the start of this vehicle's activation this vehicle may choose to activate the EXPERIMENTAL TELEPORTER. Gain 3 hazard tokens, and then roll a single skid die.\n\nIf the skid dice result is any result other than a hazard, place this vehicle anywhere within medium range of it's current position, not touching an obstruction or terrain, and without altering the vehicle's facing. This cannot cause a collision.\n\nIf the skid dice result is a hazard, the player to the left of the controller of the active vehicle places this vehicle anywhere within long range of its current position, not touching an obstruction or terrain, without altering its facing. This cannot cause a collision."
    ]


prisonCars : List VehiclePerk
prisonCars =
    [ VehiclePerk "Prison Car"
        0
        "Reduce the cost of this vehicle by 4 Cans. Reduce the hull value of this vehicle by 2. May only be purchased by middleweight vehicles."
    ]
