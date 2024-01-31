extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var Flurry1 = $Flurry1
onready var Flurry2 = $Flurry2
onready var Ender = $Ender
onready var Ender2 = $Ender2
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
	hit_opponent = false
	._enter()
	_add(Flurry1, 1, 0)
	_add(Flurry2, 1, 0)
	_add(Ender, 3, 6)
	_add(Ender2, 3, 6)
	
	_add(Flurry1, 1, 0)
	_add(Flurry2, 1, 0)
	_add(Ender, 3, 6)
	_add(Ender2, 3, 6)
	hit_opponent = false
	"""
	hitbox_register = {
		flurry1: {"Hits":1, "Ticks":3},
		flurry2: {"Hits":1, "Ticks":3},
		ender: {"Hits":3, "Ticks":7}
	}
	"""
	host.no_escape = 8
	Flurry1.scale_combo = true
	Flurry2.scale_combo = true
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
	#host.apply_forces_no_limit()
	if current_tick > 9:
		do_reset -= 1
		Flurry1.dir_x = host.get_vel().x
		Flurry1.dir_y = fixed.add(host.get_vel().y, host.gravity)
		
		Flurry2.dir_x = host.get_vel().x
		Flurry2.dir_y = fixed.add(host.get_vel().y, host.gravity)
	if hit_opponent == true:
		if current_tick < end_on_tick:
			var pos = host.get_pos()
			var opos = host.opponent.get_pos()

			host.opponent.set_vel(0, 0)
			host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))
	
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if (hitbox != Ender):
		host.melee_attack_combo_scaling_applied = false
	if obj is Fighter and (hitbox == Flurry1 or hitbox == Flurry2):
		var vel = host.get_vel()
		#if not fixed.eq(vel.x, "0") and fixed.sign(vel.x) != host.get_opponent_dir():
			#host.update_facing()
		host.update_facing()
		Flurry1.scale_combo = false
		Flurry2.scale_combo = false
		host.visible_combo_count += 1
		if not reset_handler:
			reset_handler = true
			var store_vel = host.get_vel()
			store_vel.x = _fixed_clamp(store_vel.x, "-8.0", "8.0")
			store_vel.y = _fixed_clamp(store_vel.y, "-8.0", "8.0")
			host.set_vel(store_vel.x, store_vel.y)
		if do_reset > 0:
			track("0.2")
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


