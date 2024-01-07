extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var movement_mod = "1.0"

const MOVE_DIST = "200"

func _tick():
	._tick()
	host.apply_forces_no_limit()
	#print(host.get_vel())

func _frame_0():
	host.dedication_stacks -= 1
	if data == null:
		data = {
			"x":0, 
			"y":0
		}
	host.penalty -= 40
	#var dir = xy_to_dir(data.x, data.y, MOVE_DIST)
	
	
	var send = data.duplicate()
	send.x = fixed.round(fixed.mul(str(send.x), movement_mod))
	send.y = fixed.round(fixed.mul(str(send.y), movement_mod))
	#print(data)
	host.dedication = send
	host.dedication_delay = 2

func _frame_1():
	host.start_projectile_invulnerability()
	
func _exit():
	._exit()
		
	host.end_projectile_invulnerability()
