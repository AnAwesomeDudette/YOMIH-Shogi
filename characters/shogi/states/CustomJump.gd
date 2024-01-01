extends "res://characters/states/Jump.gd"

func jump():
	var back = fixed.sign(str(data["x"])) != host.get_facing_int() or data["x"] == 0
	if back:
		y_modifier = "0.8"
		x_modifier = "0.5"
	else:
		y_modifier = "1.2"
		x_modifier = "1.0"
	.jump()
