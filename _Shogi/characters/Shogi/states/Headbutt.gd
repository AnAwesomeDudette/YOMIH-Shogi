extends "res://_Shogi_Git/YOMIH-Shogi/_Shogi/characters/Shogi/states/ShogiState.gd"

func _frame_4():
	if host.is_grounded():
		if host.initiative:
			host.start_aerial_attack_invulnerability()
		anim_name = "Headbutt"
	else:
		anim_name = "HeadbuttAerial"
		
		
func _frame_7():
	host.end_aerial_attack_invulnerability()
