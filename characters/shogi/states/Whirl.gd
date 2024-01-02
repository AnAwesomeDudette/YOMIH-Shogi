extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var flurry1 = $Flurry1
onready var flurry2 = $Flurry2
onready var ender = $Ender

var has_armor = false
var do_reset = 6
var reset_handler = false

func _enter():
	._enter()
	_add(flurry1, 1, 0)
	_add(flurry2, 1, 0)
	_add(ender, 3, 6)
	
	_add_f(flurry1, 0)
	_add_f(flurry2, 0)
	_add_f(ender, 5)
	"""
	hitbox_register = {
		flurry1: {"Hits":1, "Ticks":3},
		flurry2: {"Hits":1, "Ticks":3},
		ender: {"Hits":3, "Ticks":7}
	}
	"""
	host.no_escape = 8
	flurry1.scale_combo = true
	flurry2.scale_combo = true
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
	if current_tick > 9:
		do_reset -= 1
	flurry1.dir_x = host.get_vel().x
	flurry1.dir_y = fixed.add(host.get_vel().y, host.gravity)
	
	flurry2.dir_x = host.get_vel().x
	flurry2.dir_y = fixed.add(host.get_vel().y, host.gravity)
	
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if obj is Fighter and (hitbox == flurry1 or hitbox == flurry2):
		var vel = host.get_vel()
		if not fixed.eq(vel.x, "0") and fixed.sign(vel.x) != host.get_opponent_dir():
			host.update_facing()
		flurry1.scale_combo = false
		flurry2.scale_combo = false
		host.visible_combo_count += 1
		if not reset_handler:
			reset_handler = true
			var store_vel = host.get_vel()
			store_vel.x = _fixed_clamp(store_vel.x, "-8.0", "8.0")
			store_vel.y = _fixed_clamp(store_vel.y, "-8.0", "8.0")
			host.set_vel(store_vel.x, store_vel.y)
		if do_reset > 0:
			track("0.2")

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


