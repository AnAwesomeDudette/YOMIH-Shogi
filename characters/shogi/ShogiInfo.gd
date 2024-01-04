extends PlayerInfo

var dedication_modifier = ""


func set_fighter(fighter):
	.set_fighter(fighter)
	$"%HBoxContainer".alignment = BoxContainer.ALIGN_BEGIN if player_id == 1 else BoxContainer.ALIGN_END

func _process(delta):
	$"%DedicationLabel".text = str(fighter.dedication_stacks) + dedication_modifier
	if ReplayManager.playback or ReplayManager.replaying_ingame:
		rect_position.y = -40
	else:
		rect_position.y = -10
		
