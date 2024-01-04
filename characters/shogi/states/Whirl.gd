extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var _c_drag = 0
export (bool) var drag = false
export (int) var offset_x = 0
export (int) var offset_y = 0
export (int) var end_on_tick = 1
export (int) var drag_strength = 10

var hit_opponent = false

var has_armor = false
var do_reset = 6
var reset_handler = false

func _enter():
	._enter()

	hit_opponent = false
	"""
	hitbox_register = {
		flurry1: {"Hits":1, "Ticks":3},
		flurry2: {"Hits":1, "Ticks":3},
		ender: {"Hits":3, "Ticks":7}
	}
	"""
	host.no_escape = 8
	do_reset = 6
	reset_handler = false

func _frame_6():
	if not host.has_hyper_armor:
		host.has_hyper_armor = true
	else:
		has_armor = true
	
func _frame_9():
	if not has_armor:
		host.has_hyper_armor = false

func _exit():
	host.no_escape = 8
	if not has_armor:
		host.has_hyper_armor = false

func _tick():
	._tick()
	if hit_opponent == true:
		if current_tick < end_on_tick:
			var pos = host.get_pos()
			var opos = host.opponent.get_pos()

			host.opponent.set_vel(0, 0)
			host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))
	
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if current_tick < end_on_tick:
		if obj == host.opponent:
			hit_opponent = true

func on_attack_blocked():
	track("0.3")

func _fixed_clamp(
	n:String, 
	start:String, end:String
):
	if host.fixed.lt(n, start):
		return start
	elif host.fixed.gt(n, end):
		return end
	else :
		return n


