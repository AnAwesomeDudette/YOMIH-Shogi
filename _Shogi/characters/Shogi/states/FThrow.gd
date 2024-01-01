extends ThrowState

onready var hitbox = $Bouncebox
var failsafe = false
const AWESOMENESS = 5

func _frame_11():
	failsafe = false
	if host.opponent.current_state().name == "Grabbed":
		failsafe = true
	host.global_hitlag(AWESOMENESS)

func _frame_15():
	if failsafe:
		hitbox.hit(host.opponent)
