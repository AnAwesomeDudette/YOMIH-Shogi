extends PlayerExtra

func _ready():
	$"%DropButton".connect("pressed", self, "emit_signal", ["data_changed"])
	$"%Conquer".connect("data_changed", self, "emit_signal", ["data_changed"])

func get_extra():
	return {
		"drop_enabled":$"%DropButton".pressed,
		"conquer_tier":$"%Conquer/Direction".value,
	}

func update_selected_move(move_state):
	.update_selected_move(move_state)

func show_options():
	if fighter.is_grounded():
		$"%DropButton".hide()
	else:
		$"%DropButton".show()

func _process(delta):
	if not (selected_move is preload("res://_Shogi/characters/shogi/states/ShogiState.gd")):
		$"%Conquer".hide()
	else:
		if not selected_move.can_conquer:
			$"%Conquer".hide()
			$"%Conquer/Direction".value = 0
		else:
			var color = Color("ff006f")
			if fighter:
				
				if fighter.is_color_active and fighter.style_extra_color_2:
					color = fighter.style_extra_color_2
					
				var val_range = $"%Conquer".max_value - $"%Conquer".min_value
				var val = $"%Conquer/Direction".value - $"%Conquer".min_value
				var r = abs(color.r - 1.0)
				var g = abs(color.g - 1.0)
				var b = abs(color.b - 1.0)
				
				r = r * (val/val_range)
				g = g * (val/val_range)
				b = b * (val/val_range)
				
				color = Color(1.0 - r, 1.0 - g, 1.0 - b)
				$"%Conquer".modulate = color
			else:
				$"%Conquer".modulate = Color(1.0, 1.0, 1.0)
			$"%Conquer".show()

func reset():
	$"%DropButton".set_pressed_no_signal(false)
	$"%Conquer/Direction".value = 0
