extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var hitbox1 = $WEHitErase
onready var hitbox2 = $WEHitErase2

func _enter():
	._enter()
	_add(hitbox1, 7000, 2)
	_add(hitbox2, 7000, 2)

func _frame_15():
	host.stance = "Conquer"
