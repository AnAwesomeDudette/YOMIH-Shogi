extends "res://_Shogi_Git/YOMIH-Shogi/_Shogi/characters/Shogi/states/ShogiState.gd"

onready var a1 = $A1
onready var a2 = $A2
onready var a3 = $A3
onready var b1 = $B1
onready var b2 = $B2

func _enter():
	._enter()
	_add(a1, 2, 2)
	_add(a2, 2, 2)
	_add(a3, 2, 2)
	_add(b1, 2, 2)
	_add(b2, 2, 2)
