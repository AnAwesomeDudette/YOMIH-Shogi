extends PlayerExtra

var ghost : Fighter

var max_delay = 4
var delay = max_delay
var text = "Guard Break on Conquer Level 3"

func set_fighter(fighter):
	.set_fighter(fighter)
	fighter.info_ui = self

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
	
	if is_instance_valid(ghost):
		ghost.gb_label.hide()
		if selected_move is preload("res://_Shogi/characters/shogi/states/Split.gd"):
			#if not fighter.current_state().get("do_show") == true:
				#print("Should show")
				
				if $"%Conquer/Direction".value == 3:
					#print(ghost.current_state()
					if ghost.current_state().name == "Split":
						if ghost.current_state().get("overdesign") == false:
							text = "[~16f]"
						else:
							text = "[~18f]"
				else:
					text = "Guard Break on Conquer Level 3"	
				ghost.gb_label.text = text
				
				if fighter.opponent and fighter.opponent.is_in_hurt_state():
					delay = 1
				
				if delay == 0:
					ghost.gb_label.show()
				else:
					delay -= 1
		else:
			delay = max_delay
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
