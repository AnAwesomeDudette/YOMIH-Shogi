extends CharacterState

var game_time = 3600
var state_variables = {}

func _enter():
	game_time = Global.current_game.time
	host.start_invulnerability()

func _frame_0():
	for v in host.opponent.state_variables:
		state_variables[v] = host.opponent.get(v)

func _tick():
	host.penalty = 0
	host.opponent.penalty = 0
	var game = Global.current_game
	if(game.time-game.current_tick<game_time):
		game.time+=1
	if host.opponent.stance != "Intro" and current_tick < 119:
		for v in state_variables.keys():
			host.opponent.set(v,state_variables[v])
		host.opponent.hitlag_ticks = 1
		host.opponent.state_interruptable = false
	if current_tick == 119:
		host.opponent.state_interruptable = true
		host.state_interruptable = true
		host.stance = "Normal"
		return "Wait"

func _frame_52():
	host.play_sound("IntroExplode")
	$"./Dialogue".show()
	$"./Dialogue".text = host.Dialogue.GetLine(host.getOpponentName(), "Intro", Network.pid_to_username(host.opponent.id))

func _exit():
	$"./Dialogue".hide()
	host.end_invulnerability()
