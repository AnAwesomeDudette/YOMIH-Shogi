extends PlayerInfo

var dedication_modifier = ""

var raid_elements = []

func set_fighter(fighter):
	.set_fighter(fighter)
	$"%HBoxContainer".alignment = BoxContainer.ALIGN_BEGIN if player_id == 1 else BoxContainer.ALIGN_END

func _ready():
	raid_elements = [
		$"%RaidTex1",
		$"%RaidTex2",
		$"%RaidTex3",
		$"%RaidTex4",
	]

func _process(delta):
	$"%DedicationLabel".text = str(fighter.dedication_stacks) + dedication_modifier
	if ReplayManager.playback or ReplayManager.replaying_ingame:
		rect_position.y = -40
	else:
		rect_position.y = -10
	for i in range(raid_elements.size()):
		if i < fighter.raid_stacks:
			raid_elements[i].show()
		else:
			raid_elements[i].hide()
		
