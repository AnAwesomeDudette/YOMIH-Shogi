extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

const MOVE_DIST = "200"

func _frame_0():
	if data == null:
		data = {
			"x":0, 
			"y":0
		}
	#var dir = xy_to_dir(data.x, data.y, MOVE_DIST)
	
	host.dedication = data
	host.dedication_delay = 2
