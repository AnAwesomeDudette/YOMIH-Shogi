extends CharacterState

var super_level = 4
onready var TauntSong = $"%ShogiTaunt"


func _ready():
	pass

func _enter():
	if not $"%ShogiTaunt".playing:
		host.play_sound("ShogiTaunt")
	host.queue_damage_multiplier = 0.7



func _tick():
	host.gain_super_meter(10)
	#print(TauntSong.playing)
	host.start_projectile_invulnerability()
	host.penalty = 25

func _frame_44():
	host.unlock_achievement("ACH_HUSTLE", true)

func _frame_70():
	if host.opponent.current_state().endless == true:
		host.opponent.current_state().enable_interrupt()

func _exit():
	host.stop_sound("ShogiTaunt")
	host.end_projectile_invulnerability()
	
