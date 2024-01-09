const Lines = {
	"Template": {
		"Intro": "Appears on round start.",
		"IntroLeft": "Appears on round start, but only if on the left side.",
		"IntroRight": "Appears on round start, but on the... right!",
		"Custom1": "Used in a situation you define. You can add more of these freely.",
		"Win": "Used on win.",
		"Lose": "Used on loss."
	},

	"Example": {
		"Intro": "I will win!",
		"Custom1": "Not every line needs a value!",
		"Win": "I just won the match!",
	},

	"Default": { #Required in case dialogue isn't found. It doesn't need any entries, but a 'Default' slot must exist.
		"Intro": "Patience is a virtue...",
		"Win": "Too reckless",
	},

	"Shogi": { #Required in case dialogue isn't found. It doesn't need any entries, but a 'Default' slot must exist.
		"Intro": "Do not imitate me, fool...",
		"Win": "Take my shape and take my pain.",
	},
#Base Roster Start
	"Robot": {
		"Intro":"Machine... Turn back now...",
		"Win": "Your systems are outdated.",
	},
	
	"Cowboy": {
		"Intro":"You call yourself a cowboy?",
		"Win": "Next time, bring more bullets",
	},

	"Wizard": {
		"Intro":"Does this world not forbid magic?",
		"Win": "A world without magic bans...",
	},

	"Ninja": {
		"Intro":"Parlor tricks only go so far.",
		"Win": "You have impressive pocket size.",
	},
#Base Roster End. Lore Related Start
	"Royalty": {
		"Intro": "What matters is we move on.",
		"Win": "I wish you luck in your grievances",
	},

	"Thalia": {
		"Intro":"When do we obtain freedom?",
		"Win": "It seems we have much to learn...",
	},

	"Phobophobia": {
		"Intro":"Why do I feel... scared?",
		"Win": "My fears will not hinder me.",
	},

	"Slimpurt": {
		"Intro":"You resemble a companion...",
		"Win": "You are, however, more aggressive",
	},
#Lore Related End. Large Swords Start
	"BigSword": {
		"Intro":"Your Power Lacks Elegance",
		"Win": "Might I suggest a smaller weapon?",
	},

	"The Hammerfall": {
		"Intro":"Your Husband Lacks Elegance",
		"Win": "Is your husband even safe?",
	},

	"Colossus": {
		"Intro":"Power doesn't compensate Elegance",
		"Win": "Might I suggest a smaller weapon?",
	},

	"Monolith": {
		"Intro":"Your sword is unwieldy",
		"Win": "Might I suggest a smaller weapon?",
	},
# Large Swords End, Rushdowns Start
	"Vixen": {
		"Intro":"I was once hot-headed too...",
		"Win": "recklessness doesn't go far...",
	},

	"Thaiger": {
		"Intro":"Nothing Is unstoppable",
		"Win": "recklessness doesn't go far...",
	},
#Rushdowns End, Underrateds Start

	"Shenn Nobi": {
		"Intro":"Release your potential",
		"Win": "You should have listened...",
	},
#Underrateds End, Personals Start

	"Omega": {
		"Intro":"The real you is no Messiah",
		"Win": "Destruction is not everything",
	},

	"Elder": {
		"Intro":"Drop the Elderly Facade",
		"Win": "You had your chance",
	},

	"Moonwalker": {
		"Intro":"A dance style for combat?",
		"Win": "Not very practical, it seems.",
	},

	"Miko": {
		"Intro":"Much like me, you don't yield",
		"Win": "I saw much potential."
	},

	"Boomeranger": {
		"Intro":"Your practices are fascinating",
		"Win": "Unfortunate that you're still reckless"
	},
}

const UsernameLines = {
	"SteamUsername": {
		"Intro": "Example Intro"
	},
#Truly Special People Start
	"Piggyfriend1792": {
		"Intro": "You remind me of an... Impostor."
	},

	"AnAwesomeDudette": {
		"Intro": "I was told to call you '223'"
	},

	"the slopparition": {
		"Intro": "Why do you call yourself 'Upid'?"
	},

	"ThatBox": {
		"Intro": "Don't care"
	},

	"JakeLore": {
		"Intro": "No signs of schizophrenia yet..."
	},

	"A Bit of Pix": {
		"Intro": "I thank you for inspiring my creator."
	},

	"Cherry": {
		"Intro": "Don't carry your burdens alone"
	},

	"Trinity": {
		"Intro": "Fancy meeting you here, creator"
	},

	"TriMay": {
		"Intro": "Your knowledge of creation rivals gods..."
	},

#SUPPORTER DIALOGUE
	"Eminence": {
		"Intro": "I know only one emperor and it's not you..."
	},

	"8BitClouds": {
		"Intro": "Observant from the beginning, I see."
	},

}

static func GetLine(name, option, username): #Gets a dialogue line. Argument 1 is the opponent name, argument 2 is the type of line.
	var isDefault = name == "Default" #Used to prevent infinite loops if the default set doesn't have dialogue.
	var set = UsernameLines.get(username) #Get the dialogue set for the character.
	if set == null:
			
		set = Lines.get(name) #Get the dialogue set for the character.
		if set == null:
			if isDefault: #Prevent infinite loops.
				return null 
			return GetDefualtValue(option, username) #Returns default dialogue if one is not found for the character.
		
	if (option == "IntroLeft" || option == "IntroRight") && set.get(option) == null: #If we're doing a left/right intro but the character doesn't have one, instead use a generic intro line.
		option = "Intro"
	
	var output = set.get(option) #Look for the line based on what option we've picked.
	if output == null: #If it doesn't exist,
		if isDefault: #Prevent infinite loops.
			return null 
		return GetDefualtValue(option, username) #Get the default.
	return output #Get our unique line.

static func GetDefualtValue(option, username): #For fallback.
	return GetLine("Default", option, username) #Pretend the name of the enemy is "Default" to access our default set.



