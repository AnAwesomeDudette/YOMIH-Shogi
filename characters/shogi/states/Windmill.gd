extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

#oh. why have i done this to myself
#it is time for me to pay
#pay for the crimes i have committed
#pay the consequences
#of my actions

#its so over

onready var a1 = $A1
onready var a2 = $A2
onready var a3 = $A3
onready var b1 = $B1
onready var b2 = $B2
onready var b3 = $B3
onready var c1 = $C1
onready var c2 = $C2
onready var c3 = $C3
onready var d1 = $D1
onready var d2 = $D2
onready var d3 = $D3
onready var e1 = $E1
onready var e2 = $E2
onready var e3 = $E3

var trigger = false

func _enter():
	._enter()
	trigger = false
	_add(a1, 2, 1)
	_add(a2, 2, 1)
	_add(a3, 2, 1)
	_add(b1, 2, 1)
	_add(b2, 2, 1)
	_add(b3, 2, 1)
	_add(c1, 2, 1)
	_add(c2, 2, 1)
	_add(c3, 2, 1)
	_add(d1, 2, 1)
	_add(d2, 2, 1)
	_add(d3, 2, 1)
	_add(e1, 2, 1)
	_add(e2, 2, 1)
	_add(e3, 2, 1)

#i hate fun
var startup_lag = 0

func _frame_3():
	if not started_in_air:
		if not trigger:
			startup_lag = 3
			trigger = true

func _tick():
	if current_tick >= 1 and startup_lag > 0:
		startup_lag -= 1
		current_tick = 1
	._tick()

"""
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if obj is Fighter:
		var par = host._spawn_particle_effect(particle_scene, Vector2(hitbox.x * host.get_facing_int(), hitbox.y), Vector2())
		var random_angle = host.randi_range(0, 361)
		par.rotation_degrees = random_angle
"""
