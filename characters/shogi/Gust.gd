extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var a1 = $A1
onready var b1 = $B1


func _enter():
	._enter()
	_add(a1, 1, 1)
	_add(b1, 1, 1)


