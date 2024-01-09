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

func _frame_44():
	host.unlock_achievement("ACH_HUSTLE", true)

func is_usable():
	var new_usable = host.supers_available >= super_level and host.Fear >= host.Fear_AMOUNT
	return .is_usable() and (not new_usable or host.install_active)

func _exit():
	host.stop_sound("ShogiTaunt")

