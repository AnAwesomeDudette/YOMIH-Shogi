extends CharacterState

var super_level = 4
onready var TauntSong = $"%ShogiTaunt"


func _ready():
	pass

func _enter():
	if not $"%ShogiTaunt".playing:
		host.play_sound("ShogiTaunt")



func _tick():
	host.gain_super_meter(6)
	#print(TauntSong.playing)
	host.start_projectile_invulnerability()

func _frame_44():
	host.unlock_achievement("ACH_HUSTLE", true)

func _frame_70():
	if host.opponent.current_state().endless == true:
		host.opponent.current_state().enable_interrupt()

func is_usable():
	var new_usable = host.supers_available >= super_level and host.Fear >= host.Fear_AMOUNT
	return .is_usable() and (not new_usable or host.install_active)

func _exit():
	host.stop_sound("ShogiTaunt")
	host.end_projectile_invulnerability()
	
