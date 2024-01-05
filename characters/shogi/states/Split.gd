extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var a1 = $A1
onready var a2 = $A2
onready var a3 = $A3
onready var b1 = $B1
onready var b2 = $B2

var overdesign = false

func conquer_tier_3():
	.conquer_tier_3()
	a1.guard_break = true
	a2.guard_break = true
	a3.guard_break = true
	a1.block_punishable = true
	a2.block_punishable = true
	a3.block_punishable = true
	b1.guard_break = true
	b2.guard_break = true

func _enter():
	overdesign = false
	a1.guard_break = false
	a2.guard_break = false
	a3.guard_break = false
	a1.block_punishable = false
	a2.block_punishable = false
	a3.block_punishable = false
	b1.guard_break = false
	b2.guard_break = false
	._enter()

	_add(a1, 2, 2)
	_add(a2, 2, 2)
	_add(a3, 2, 2)
	_add(b1, 2, 2)
	_add(b2, 2, 2)

func _frame_1():
	if host.opponent and host.get_facing() == host.opponent.get_facing():
		overdesign = true
	else:
		overdesign = false

func _tick():
	._tick()
	host.apply_forces_no_limit()
