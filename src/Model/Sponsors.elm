module Model.Sponsors exposing
    ( PerkClass(..)
    , Sponsor
    , TeamPerk
    , VehiclePerk
    , aggression
    , allSponsors
    , badass
    , daring
    , defaultSponsor
    , fromPerkClass
    , getClassPerks
    , military
    , precision
    , prisonCars
    , pursuit
    , speed
    , stringToSponsor
    , technology
    , tuning
    )


type alias Sponsor =
    { name : String
    , description : String
    , perks : List TeamPerk
    , grantedClasses : List PerkClass
    }


type PerkClass
    = Aggression
    | Badass
    | Built
    | Daring
    | Horror
    | Military
    | Precision
    | Pursuit
    | Reckless
    | Speed
    | Technology
    | PrisonCars
    | Tuning


fromPerkClass : PerkClass -> String
fromPerkClass perkClass =
    case perkClass of
        Aggression ->
            "Aggression"

        Badass ->
            "Badass"

        Built ->
            "Built"

        Daring ->
            "Daring"

        Horror ->
            "Horror"

        Military ->
            "Military"

        Precision ->
            "Precision"

        Pursuit ->
            "Pursuit"

        Reckless ->
            "Reckless"

        Speed ->
            "Speed"

        Technology ->
            "Technology"

        PrisonCars ->
            "PrisonCars"

        Tuning ->
            "Tuning"


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
    , scarlett
    , highwayPatrol
    , verney
    , maxxine
    , orderOfTheInferno
    , beverly
    , rustysBootleggers
    ]


getClassPerks : PerkClass -> List VehiclePerk
getClassPerks perkClass =
    case perkClass of
        Aggression ->
            aggression

        Badass ->
            badass

        Built ->
            built

        Daring ->
            daring

        Horror ->
            horror

        Military ->
            military

        Precision ->
            precision

        Pursuit ->
            pursuit

        Reckless ->
            reckless

        Speed ->
            speed

        Technology ->
            technology

        PrisonCars ->
            prisonCars

        Tuning ->
            tuning


stringToSponsor : String -> Maybe Sponsor
stringToSponsor name =
    allSponsors
        |> List.filter (\sp -> sp.name == name)
        |> List.head



-- SPONSORS.


defaultSponsor : Sponsor
defaultSponsor =
    Sponsor
        ""
        ""
        []
        []


rutherford : Sponsor
rutherford =
    { defaultSponsor
        | name = "Rutherford"
        , description = "Grant Rutherford is the son of a militaristic American oil baron. He is aggressive, rich and uncompromising. His beaming face, beneath his trademark cream Stetson, adorns billboard advertisements for his high-quality and high-priced Rutherford brand weaponry. Teams sponsored by Rutherford get access to military surplus, missile launchers, tanks and helicopters and as much ammo as they can carry. After his team won in 2016, he was only too happy to kiss the Earth goodbye and now runs his company from his highly exclusive Martian office."
        , perks =
            [ TeamPerk "Military Hardware"
                "This team may purchase a single Tank. This team may purchase a single Helicopter."
            , TeamPerk "Well Stocked"
                "This team considers any weapon with the ammo 3 special rule to instead have the ammo 4 special rule when purchased."
            , TeamPerk "Might Is Right"
                "This team may not purchase lightweight vehicles."
            , TeamPerk "Televised Carnage"
                "If a vehicle in this team causes 6 or more hits in a single attack step, before evades, this team gains +1 audience votes."
            ]
        , grantedClasses = [ Badass, Military ]
    }


miyazaki : Sponsor
miyazaki =
    { defaultSponsor
        | name = "Miyazaki"
        , description = "Yuri Miyazaki grew up in the rubble of Tokyo, fighting her way to the top of the speedway circuit with incredible feats of daring and vehicular agility. She has a small fleet of elite couriers who run jobs for the wealthiest or most desperate clients. It is whispered that she also runs guns for the Pro-Earth Resistance, but no one who spreads that rumour lives long enough to spread it far. Miyazaki's drivers are unsurpassed in their skill and finesse."
        , perks =
            [ TeamPerk "Virtuoso"
                "The first time each vehicle in this team uses push it in an activation they may push it without gaining a hazard token."
            , TeamPerk "Evasive Maneuvers"
                "Before making an evade roll, vehicles in this team may gain any number of hazard tokens to add +1 to each of their evade dice for each hazard token gained. A roll of \"1\" on an evade dice always counts as a failure."
            , TeamPerk "Elegance"
                "Teams sponsored by Miyazaki may not purchase Pickup Trucks, Buses or War Rigs."
            , TeamPerk "Showing Off"
                "Once per gear phase, if all of this team's in-play vehicles activated, resolved at least on un-canceled spin result, resolved at least one un-canceled slide result, resolved at least on stick-shift, and did not wipe out, this team gains +1 audience vote for each of this team's in-play vehicles."
            ]
        , grantedClasses = [ Daring, Precision ]
    }


mishkin : Sponsor
mishkin =
    { defaultSponsor
        | name = "Mishkin"
        , description = "Andre Mishkin is not a natural sportsman. However, the brilliant Russian engineer and inventor proves in 2010 that technology is just as solid an answer as skill or ferocity on the track. From his research and development facility on Mars he continues to send designs for unusual and devastating weapons and sleep, hi-tech vehicles to Earth for field-testing by the teams he sponsors."
        , perks =
            [ TeamPerk "Thumpermonkey"
                "This team may purchase electrical weapons and upgrades."
            , TeamPerk "Dynamo"
                "After activating in gear Phase 4, 5 or 6, this vehicle may add +1 ammo tokens to a single electrical weapon or upgrade on that vehicle."
            , TeamPerk "All the Toys"
                "Whenever a vehicle in this team attack with a named weapon that has not been attacked with by any vehicle during this game yet this team gains +1 audience vote."
            ]
        , grantedClasses = [ Military, Technology ]
    }


idris : Sponsor
idris =
    { defaultSponsor
        | name = "Idris"
        , description = "Yandi Idris is an addict. From the first time the hot and sweet fumes of a singing petrol engine filled his nose he could find no other joy. He said that the first time he pressed that nitro-oxide button was like touching the face of God. Mystical, irrational and dangerous, the Cult of Speed spread like wildfire after Idris' meteoric rise during the 2012 Gaslands season. He crossed the final finishing line in a ball of fire and his body was never found. His fanatical followers say that at 201mph you can hear his sonorous voice on the rushing head wind."
        , perks =
            [ TeamPerk "N2O Addict"
                "This team may purchase the Nitro upgrade at half the listed cost."
            , TeamPerk "Speed Demon"
                "When using Nitro, vehicles in this team only gain hazard tokens until they have 3 hazard tokens after each of the two activation, rather than the normal 5."
            , TeamPerk "Cult of Speed"
                "If a vehicle in this team selects the long straight maneuver template in movement step 1.1 during gear phase 1, 2 or 3, this team gains +1 audience vote."
            , TeamPerk "Kiss My Asphalt"
                "This team may not purchase Gyrocopters."
            ]
        , grantedClasses = [ Precision, Speed ]
    }


slime : Sponsor
slime =
    { defaultSponsor
        | name = "Slime"
        , description = "Slime rules a wild and feral city in the Australian wastes known as Anarchy. Young people crawled out of the wreckage of the scorched earth in their thousands to rally round her ragged banner. The wild-eyed and whooping joyful gangs of Anarchy are led by Slime's henchwomen, the Chooks, who seek fame and adoration from the global Gaslands audience."
        , perks =
            [ TeamPerk "Live Fast"
                "If a vehicle in this tam begins the wipeout step with more hazard tokens than hull points during its own activation this team gains +1 audience vote."
            , TeamPerk "Pinball"
                "If a vehicle in this team is involved in a sideswipe smash attack during its activation, immediately resolve another movement step with that vehicle after the current movement step."
            ]
        , grantedClasses = [ Aggression, Speed ]
    }


warden : Sponsor
warden =
    { defaultSponsor
        | name = "Warden"
        , description = "Warden Cadeila is proud to live in Sao Paulo, a shining hub of humanity and relatively untouched by the war. The Sao Paulo People's Penitentiary has three of Gaslands' top ten teams in the past decade, and the Warden continues to grant her prisoners a chance at freedom as long as the Gaslands franchise continues to deliver the sponsorship deals. The deal isn't great from the damned souls who are welded into the Warden's solid steel \"coffin cars\", but it's better than the alternative."
        , perks =
            [ TeamPerk "Prison Cars"
                "Vehicles in this team may purchase the Prison Cars upgrade."
            , TeamPerk "Fireworks"
                "If a vehicle belonging to this team explodes, gain +1 audience vote if it was middleweight or +2 audience votes if it was heavyweight in addition to any votes gained for being wrecked, and then discard all ammo tokens from the wreck."
            ]
        , grantedClasses = [ Aggression, Badass, PrisonCars ]
    }


scarlett : Sponsor
scarlett =
    { defaultSponsor
        | name = "Scarlett Annie"
        , description = "Gaslands is able to support a vast ecosystem of villainous and scurvy raiders, picking off richer teams as their rigs roll from one televised race to the next. Many of these self-styled pirate crews have gained renown, but none have rivalled the infamy or showmanship of Scarlett Annie. A dashing and flamboyant buccaneer, her cult following is likely more to do with her canny association with the long-running \"Death Valley Death Run\" documentary TV series than any particular skill at dust bowl piracy."
        , perks =
            [ TeamPerk "Crew Quarters"
                "This team may purchase the Extra Crewmember upgrade at half the listed cost."
            , TeamPerk "Raiders"
                "At the end of the attack step, this vehicle may permanently reduce its crew value by any number, to a minimum of 0 crew: remove 1 hull point from any vehicle in base contact for each crew removed in this way."
            , TeamPerk "Raise the Sails"
                "After rolling skid dice, this vehicle may permanently  reduce its crew value by 1, to a minimum of 0 crew to add 1 free shift result to the skid dice result."
            , TeamPerk "Press Gang or Keelhaul"
                "When another vehicle in contact with this vehicle is wrecked, this vehicle may gain either 1 crew or 2 audience votes."
            ]
        , grantedClasses = [ Tuning, Aggression ]
    }


highwayPatrol : Sponsor
highwayPatrol =
    { defaultSponsor
        | name = "Highway Patrol"
        , description = "Along the Wrecked and broken highways, where law is another word fir vengeance, and justice is a forgotten memory; a handful of souls still cling to a dream of order Perhaps they do it for the glory. Maybe they even get a kick out of it. They are unsanctioned unloved and unpaid. Their only power: a badge of bronze. Their only weapon: 600 horsepower of fuel-injected steel. The Highway Patrol are the last law in a world gone crazy."
        , perks =
            [ TeamPerk "Hot Pursuit" "Before the first Gear Phase of the game, after deployment, this team must nominate one enemy vet - the \"bogey\". If the bogey is Wrecked or disqualified, immediately n, another enemy vehicle to be the bogey."
            , TeamPerk "Bogey at 12 o'clock" "At the end of this Movement Step, if the bogey in is this vehicle's front Arc of Fire, and further than Double Range away, and can be seen by this vehicle, this vehicle may immediately resolve another Movement Step."
            , TeamPerk "Siren" "At the end of this vehicle's Attack Step, if this vehicle is in the bogey's rear Arc of Fire (regardless of range), the bogey must either reduce its Gear by 1 or gain 2 Hazard Tokens."
            , TeamPerk "Steel Justice" "If the bogey wipes out, this team, as a whole, gains 2 Audience Votes. If the bogey is Wrecked this team, as a whole, gains 4 Audience Votes"

            -- TODO Teams sponsored by Highway Patrol may purchase the following upgrade: • Louder Siren (2 Cans): Replace Thogey" with "any enemy vehicle" for the purposes of the Siren special rules. e
            ]
        , grantedClasses = [ Speed, Pursuit ]
    }


verney : Sponsor
verney =
    { defaultSponsor
        | name = "Verney TODO"
        , description = "Many have taken the bent deal offered by Warden but only one has ever earned their freedom. As skilled an engineer as he is a driven the newly-freed Verney now specialised in building unique Frankenstein's monsters of vehicles for anyone who can afford his high-quality customs."
        , perks =
            [ TeamPerk "MicroPlate Armour" "Vehicles in this team may purchase the MicroPlate Armour upgrade, which costs 6 Cans, increases the vehicles Hull Value by 2, and requires 0 build slots."
            , TeamPerk "Trunk of Junk" "You may attack with any number of dropped weapons in a single activation."
            , TeamPerk "Tombstone" "If the shooting template of a shooting attack touches the rear • edge of this vehicle, this vehicle gains +1 to its Evade rolls. During this vehicle's Attack Step, this vehicle may gain 2 Hazard Tokens. If it does, all Collisions involving this vehicle are considered to be Head-on until the start of its next activation."
            , TeamPerk "That's Entertainment" "Whenever a dropped weapon template that was placed by this team is removed from play, this team gains 1 Audience Vote. "
            ]
        , grantedClasses = [ Technology, Built ]
    }


maxxine : Sponsor
maxxine =
    { defaultSponsor
        | name = "Maxxine"
        , description = "Maxxine is the current grease-smeared face of The Black Swans. While many might assume art to have been the last thing to survive the Martian bombs, The Black Swans dance their mechanised masque for a hypnotised audience. It's ballet, but the dancers weigh 4,000 pounds and are dripping in engine oil."
        , perks =
            [ TeamPerk "Dizzy" "This vehicle may resolve any number of Spin results separately • during its Movement Step, one after another. This can allow this vehicle to Spin more than 90 degrees during its Movement Step."
            , TeamPerk "Maxximum Drift" "If this vehicle resolves two Slide results in a single Movement Step, it may use the Medium Straight in place of the slide template. If this vehicle resolves three or more Slide results in a single Movement Step, it may use the Long Straight in place of the Slide template."
            , TeamPerk "Meshuggah" "When this vehicle resolves a Slide or Spin that ends within Medium range of a friendly vehicle without causing a Collision, this team gains 1 Audience Vote."
            ]
        , grantedClasses = [ Tuning, Pursuit ]
    }


orderOfTheInferno : Sponsor
orderOfTheInferno =
    { defaultSponsor
        | name = "Order of the Inferno"
        , description = "Yandi Idris is not dead. He cannot die. He rides on in the living flame. His voice can be heard in the roar of the road and the screams of superheated metal. Yandi is free, and we can be too. He has shown us the path. Only by knowing the flames can we know true freedom. Buy your copy of \"Freedom in The Flames\" today to find out more. Available from Order of the Inferno stalls at all major trading outposts."
        , perks =
            [ TeamPerk "Fire Walk With Me" "When this -would receive damage from any weapon or effect with the Fire rule, this vehicle may reduce the damage received by up to three, to a minimum of one."
            , TeamPerk "Burning Man" "If this vehicle is On Fire it gains +1 to all Evade dice."
            , TeamPerk "Cult of Flame" "At the end of the Gear Phase, if there are more enemy vehicles On Fire than there are friendly vehicles On Fire, or all enemy vehicles are On Fire, this team gains 1 Audience Vote for each friendly vehicle that is On Fire. "
            ]
        , grantedClasses = [ Horror, Speed ]
    }


beverly : Sponsor
beverly =
    { defaultSponsor
        | name = "Beverly, the Devil on the Highway"
        , description = "The low growling of the starting grid was eclipsed by an ear-splitting, dizzying sound. Eyeball-shakingly loud, the screeching was suffocating.  A single car drifted forward into the pack, windows like onyx, bumper corroded. The sound changed timbre, dropping suddenly to a sub-audible throb that tightened chests and shattered headlamps. Despite the harsh desert sun, frost began to form  on windshields. Beverly was a stupid story told to scare children. She wasn't real."
        , perks =
            [ TeamPerk "Graveyard Shift" "At the start of the game, after deployment, all vehicles in this team except one must gain the Ghost Rider special rule."
            , TeamPerk "Ghost Rider" "This vehicle ignores, and is ignored by, other vehicles at all times. This vehicle cannot be involved in Collisions. This vehicle may not make shooting attacks or be attacked with shooting weapons. This vehicle may never count towards the victory conditions of a scenario."
            , TeamPerk "Soul Anchor" "If all in-play vehicles from this team have the Ghost Rider special rule immediately remove all vehicles on this team from play."
            , TeamPerk "At the Crossroads" "This team may choose to pay only 1 Audience Vote to respawn a vehicle. If they do, the respawned vehicle must gain the Ghost Rider special rule."
            , TeamPerk "Inexorable" "If a vehicle from to, vehicle may be respawned, e-k, - that."
            , TeamPerk "Soul Harvest" "If this vehicle's wreck or out of play, the Jles would ordinarily prevent template comes into contact with an enemy vehicle, this vehicle gains Soul Token, even if the enemy vehicle is being ignored. If this vehicle's movement template comes into contact with a friendly vehicle without the Ghost Rider rule that it did not start in contact with, choose one: either gain 1 Audience Vote for each Soul token or repair two Hull Points on the vehicle without the Ghost Rider rule for each Soul Token. Then discard all Soul Tokens from this vehicle. A Ghost Rider may gain a Soul Token and give it to a friendly vehicle in the same activation, as tong as it would come into contact with the enemy vehicle first."
            ]
        , grantedClasses = [ Horror, Built ]
    }


rustysBootleggers : Sponsor
rustysBootleggers =
    { defaultSponsor
        | name = "Rusty's Bootleggers"
        , description = "Zeke Rusty and his boys been wall to wall and treetop-tall since before the world went to hell, running moonshine past Smokey back since before the big red one fell. Their stills are volatile, their delivery vehicles are ramshackle, but they still run liquor that grandpappy would be proud of.. Though none the boys can remember just how he liked it right now. Damn that gin."
        , perks =
            [ TeamPerk "Party Hard" "At the end of this vehicle's Attack Step, if this vehicle has more Hazard Tokens than the sum of the Hazard Tokens on all other enemy vehicles within Medium range combined, this vehicle's controller gains 1 Audience Vote for each enemy -ve' --/th one or more Hazard Tokens within Medium range of this v."
            , TeamPerk "Dutch courage" "Vehicles in this team .put when they have 8 Hazard Tokens."
            , TeamPerk "As Straight as I'm Able" "This vehicle does not gain a Hazard Token from the articulated rule if it selects a template that is not a Straight."
            , TeamPerk "Over the Limit" "This vehicle never considers any of the Straight movement templates to be permitted. This vehicle considers Veer to be permitted and Trivial in any Gear."
            , TeamPerk "Trailer Trash" "This team may purchase Trailers. This team must contain either: one or more Medium or Heavyweight vehicles equipped with a trailer upgrade, or a War Rig."
            , TeamPerk "Haulage" "Each vehicle on this team equipped with a trailer upgrade, and • each War Rig on this team, may equip a single trailer cargo upgrade for free. "

            -- TODO TRAILERS A trailer is an upgrade. A vehicle may be equipped with a single trailer. A War Rig may not be equipped with the trailer upgrade. A vehicle equipped with a trailer gains the Articulated, Ponderous, and Piledriver special rules, (see War Rig, page 116)
            ]
        , grantedClasses = [ Reckless, Built ]
    }



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


built : List VehiclePerk
built =
    [ VehiclePerk "Dead Weight" 2 "During this vehicle's Attack Step, this vehicle may gain 2 Hazard Tokens to count as one weight-class heavier (unless already Heavyweight) until the start of its next activation."
    , VehiclePerk "Barrel Roll" 2 "When this vehicle suffers a Flip, it may choose to place the Flip template touching the centre of either side edge or the rear edge of this vehicle, and perpendicular to that edge, instead of touching the front edge as normal."
    , VehiclePerk "Bruiser" 4 "In a Collision involving this vehicle, if this vehicle declares a reaction other than Evade against an enemy vehicle, the vehicle immediately gains one Hazard Token."
    , VehiclePerk "Splash" 5 "Once per step, when this vehicle loses one or more Hull Points, make a 1D6 attack against each vehicle within Medium range at end of that step."
    , VehiclePerk "Crusher" 7 "This vehicle gains the Up and Over special rule (See the Monster Truck rules, page 71)."
    , VehiclePerk "Feel No Pain" 8 "During an enemy vehicle's Attack Step, after an attacker has rolled all their attack dice against this vehicle, if the attacks caused a total of 2 or fewer uncancelled hits, cancel all remaining hits."
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


horror : List VehiclePerk
horror =
    [ VehiclePerk "Purifying Flames" 1 "once per activation, at the start of this vehicle's 'activation, this vehicle may s ff up to three damage to select any friendly vehicle. For each point of damage suffered via this effect, repair that number of Hull Points on the target vehicle. This damage may not be reduced. This damage counts as having the Fire rule. This effect may not be used to raise a vehicle above its starting Hull Value."
    , VehiclePerk "Ecstatic Visions" 1 "Once per activation, at the start of this vehicle's activation, this vehicle may gain up to 3 Hazard Tokens to discard 1 Hazard Token from a friendly vehicle for each Hazard Token gained."
    , VehiclePerk "Sympathy For The Devil" 1 "When this vehicle makes an Evade check, its controller may select a friendly vehicle within Medium range. Add the current Gear of the selected vehicle to this vehicle's current Gear for the purposes of this evade check. Both the selected vehicle and this vehicle suffer any unsaved damage from this attack, including any additional effects."
    , VehiclePerk "HIGHWAY TO HELL" 2 "At the end of its Movement Step, if this vehicle selected a straight template, this vehicle may suffer two damage. This damage counts as having the Fire rule. If any Hull Points are removed by this effect, this vehicle may leave its movement template (ignoring any slide template) in play as a Napalm dropped weapon template. Remove this template at the start of this vehicle's next activation. (You may wish to download and print out extra paper templates for this effect.)"
    , VehiclePerk "Violent Manifestation" 3 "When this vehicle is respawned: make an immediate attack (with attack dice based on the weight of the respawned vehicle) against every other vehicle within Medium range as if this vehicle was an exploding wreck. This explosion counts as having both the \"Blast\" and \"Fire\" rules."
    , VehiclePerk "Angel Of Death" 4 "Before making an attack, this vehicle may suffer up to three damage to add that many attack dice to a single weapon used in this attack."
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


pursuit : List VehiclePerk
pursuit =
    [ VehiclePerk "On Your Tail"
        2
        "When an enemy vehicle resolves a spin or slide move that ends within short range of this vehicle, that vehicle gains +1 hazard token."
    , VehiclePerk "Schadenfreude"
        2
        "If another vehicle within short range of this vehicle resolves a wipe out, (either before or after any flip), remove all hazard tokens from this vehicle."
    , VehiclePerk "Taunt"
        2
        "At the start of this vehicle's attack step, roll a skid die. If you roll something other than a SHIFT result, you may place that skid die result onto the dashboard of a target vehicle within short range. This skid die result must be resolved during that vehicle's next skid check, and may not be re-rolled."
    , VehiclePerk "Out Run"
        2
        "At the start of this vehicle's attack step, all vehicles within short range of this vehicle and in a current, lower gear than this vehicle gain +1 hazard token."
    , VehiclePerk "PIT"
        4
        "If this vehicle is involved in a collision with an enemy vehicle during its activation that is not head-on, it may declare a “Pursuit Intervention Technique” (PIT) against the enemy vehicle instead of declaring a SMASH ATTACK or an evade. If this vehicle declares a PIT, it may select any maneuver template the target vehicle considers hazardous in its current gear. The target vehicle must immediately resolve a movement step, during which it is forced to must use the maneuver template selected for it and may not roll any skid dice."
    , VehiclePerk "Unnerving Eye Contact"
        5
        "Enemy vehicles within short range of this vehicle may not use shift results to remove hazard tokens from their dashboard."
    ]


reckless : List VehiclePerk
reckless =
    [ VehiclePerk "Drive Angry" 1 "At the start of this vehicle's activation, this vehicle gains 1 Hazard Token."
    , VehiclePerk "Hog Wild" 2 "During a Collision resolved during a Wipeout Step, this vehicle gains +2 Smash Attack dice. "
    , VehiclePerk "In For a Penny" 2 "If this vehicle has gained six or more Hazard Tokens during this activation, it may double the attack dice of any Smash Attack it makes for the remainder of this activation. "
    , VehiclePerk "Don't Come Knocking" 4 "At the start of this vehicle's activation, it may gain 4 Hazard Tokens. If it does, this vehicle cannot gain or lose any Hazard Tokens by any means until the start of its next activation. "
    , VehiclePerk "Bigger'n You" 4 "If this vehicle is involved in a Collision, double any Smash Attack bonuses or penalties resulting from weight differences during that Collision."
    , VehiclePerk "Beerserker" 5 "When this vehicle would suffer iddon damage by 1, to a minimum of 1. reduce that this damage outside of its activat, "
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


tuning : List VehiclePerk
tuning =
    [ VehiclePerk "Fenderkiss"
        2
        "Reduce the number of attack dice rolled for smash attacks by 2 for all vehicles in collisions involving this vehicle."
    , VehiclePerk "Rear Drive"
        2
        "This vehicle may pivot about the centre of its front edge, rather than the centre of the vehicle, when resolving Spin results."
    , VehiclePerk "Delicate Touch"
        3
        "This vehicle ignores the hazard icons on maneuver templates."
    , VehiclePerk "Purring"
        6
        "This vehicle does not receive more than 1 hazard token from Spin results each turn. This vehicle does not receive more than 1 hazard token from Slide results each turn. This vehicle does not receive more than 1 hazard token from Hazard results each turn. Excess hazards are ignored. This vehicle may still elect to resolve multiple copies of each result."
    , VehiclePerk "Skiing"
        6
        "May only be taken on a Bike, Buggy, Car, or Performance Car. This vehicle may take 3 hazard tokens at the end of its activation to be ignored by other vehicles during their movement steps until the start of this vehicle's next activation. If, by ignoring this vehicle in this way, a vehicle's final position would overlap it, move that vehicle backwards along their maneuver template by the minimum amount to avoid overlapping any obstruction."
    , VehiclePerk "Momentum"
        3
        "When resolving a skid check, this vehicle may set aside any number of slide results to re-roll 1 non-slide result for each slide result set aside. When resolving a skid check, this vehicle may set aside any number for each spin results to re-roll 1 non-spin result for each spin result set aside. Set aside results must be resolved."
    ]
