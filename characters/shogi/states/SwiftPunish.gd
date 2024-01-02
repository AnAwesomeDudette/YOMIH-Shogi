extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var begin = $TheBeginning
onready var truth = $TheTruth
onready var resolve = $TheResolution
onready var end = $TheEnd

func _enter():
	._enter()
	_add(begin, 2, 2)
	_add(truth, 2, 2)
	_add(resolve, 2, 2)
	_add(end, 2, 2)
	_add_f(begin, 4)
	_add_f(truth, 4)
	_add_f(resolve, 5)
	_add_f(end, 5)
	
func _frame_2():
	host.start_throw_invulnerability()
	
func _frame_4():
	host.end_throw_invulnerability()
