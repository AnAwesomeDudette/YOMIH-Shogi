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
}

static func GetLine(name, option): #Gets a dialogue line. Argument 1 is the opponent name, argument 2 is the type of line.
	var isDefault = name == "Default" #Used to prevent infinite loops if the default set doesn't have dialogue.
	var set = Lines.get(name) #Get the dialogue set for the character.
	if set == null:
		if isDefault: #Prevent infinite loops.
			return null 
		return GetDefualtValue(option) #Returns default dialogue if one is not found for the character.
	
	if (option == "IntroLeft" || option == "IntroRight") && set.get(option) == null: #If we're doing a left/right intro but the character doesn't have one, instead use a generic intro line.
		option = "Intro"
	
	var output = set.get(option) #Look for the line based on what option we've picked.
	if output == null: #If it doesn't exist,
		if isDefault: #Prevent infinite loops.
			return null 
		return GetDefualtValue(option) #Get the default.
	return output #Get our unique line.

static func GetDefualtValue(option): #For fallback.
	return GetLine("Default", option) #Pretend the name of the enemy is "Default" to access our default set.
