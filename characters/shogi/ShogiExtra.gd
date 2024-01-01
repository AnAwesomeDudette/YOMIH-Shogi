extends PlayerExtra

func _ready():
	$"%DropButton".connect("item_selected", self, "emit_signal", ["data_changed"])
	$"%ConquerSelect".connect("data_changed", self, "emit_signal", ["data_changed"])
	

func get_extra():
	return {
		"drop_enabled":$"%DropButton".pressed,
		"conquer_tier":$"%ConquerSelect".selected
	}

func update_selected_move(move_state):
	.update_selected_move(move_state)

func show_options():
	if fighter.is_grounded():
		$"%DropButton".hide()
	else:
		$"%DropButton".show()

func _process(delta):
	if not (selected_move is preload("res://_Shogi/characters/Shogi/states/ShogiState.gd")):
		$"%ConquerSelect".hide()
	else:
		print(selected_move.can_conquer)
		if not selected_move.can_conquer:
			$"%ConquerSelect".hide()
			$"%ConquerSelect".selected = 0
		else:
			$"%ConquerSelect".show()

func reset():
	$"%DropButton".set_pressed_no_signal(false)
	$"%ConquerSelect".selected = 0
