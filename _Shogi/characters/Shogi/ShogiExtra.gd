extends PlayerExtra

func _ready():
	$"%DropButton".connect("pressed", self, "emit_signal", ["data_changed"])
	

func get_extra():
	return {
		"drop_enabled":$"%DropButton".pressed,
	}

func update_selected_move(move_state):
	.update_selected_move(move_state)

func show_options():
	if fighter.is_grounded():
		$"%DropButton".hide()
	else:
		$"%DropButton".show()

func reset():
	$"%DropButton".set_pressed_no_signal(false)
