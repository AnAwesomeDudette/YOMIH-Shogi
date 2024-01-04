extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var movement_mod = "1.0"

const MOVE_DIST = "200"

func _tick():
	._tick()
	host.apply_forces_no_limit()

func _frame_0():
	host.dedication_stacks -= 1
	if data == null:
		data = {
			"x":0, 
			"y":0
		}
	#var dir = xy_to_dir(data.x, data.y, MOVE_DIST)
	
	
	var send = data
	send.x = fixed.round(fixed.mul(str(send.x), movement_mod))
	send.y = fixed.round(fixed.mul(str(send.y), movement_mod))
	#print(data)
	host.dedication = send
	host.dedication_delay = 2
