extends CharacterState

var super_level = 4

func _ready():
	pass

func _frame_9():
	host.has_projectile_armor = true

func _frame_44():
	host.gain_super_meter(host.MAX_SUPER_METER)
	host.unlock_achievement("ACH_HUSTLE", true)
	host.has_projectile_armor = false
