extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

func _enter():
	._enter()
	if host.is_grounded():
		anim_name = "Ballet"
	else:
		anim_name = "BalletAir"
