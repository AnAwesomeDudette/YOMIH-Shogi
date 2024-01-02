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
			$"%Conquer".show()

func reset():
	$"%DropButton".set_pressed_no_signal(false)
	$"%Conquer/Direction".value = 0
