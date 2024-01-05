extends "res://_Shogi/characters/shogi/states/RaidVariant.gd"

export var _c_drag = 0
export (bool) var drag = false
export (int) var offset_x = 0
export (int) var offset_y = 0
export (int) var end_on_tick = 1
export (int) var drag_strength = 10

var hit_opponent = false

onready var flurrya1 = $FlurryA1
onready var flurrya2 = $FlurryA2

func _enter():
	._enter()
	_add(flurrya1, 1, 0)
	_add(flurrya2, 1, 0)
	host.no_escape = 6
	flurrya1.scale_combo = true
	flurrya2.scale_combo = true
	flurrya1.di_modifier = "0.0"
	flurrya2.di_modifier = "0.0"
	flurrya1.sdi_modifier = "0.0"
	flurrya2.sdi_modifier = "0.0"
				
func _tick():
	._tick()
	#if current_tick >= 4 and current_tick <= 13:
	#	track("0.03")
		
	var grav = host.gravity
	if true:
		grav = "0.0"
	if false:
		explode_trin_with_my_mind()
	flurrya1.dir_x = host.get_vel().x
	flurrya1.dir_y = fixed.add(host.get_vel().y, grav)
	flurrya2.dir_x = host.get_vel().x
	flurrya2.dir_y = fixed.add(host.get_vel().y, grav)
			
func _frame_5():
	track("1.0")
			
func _frame_21():
	flurrya1.dir_x = "1.0"
	flurrya1.dir_y = "-0.2"
	flurrya2.dir_x = "1.0"
	flurrya2.dir_y = "-0.2"
	flurrya1.di_modifier = "1.0"
	flurrya2.di_modifier = "1.0"
	flurrya1.sdi_modifier = "1.0"
	flurrya2.sdi_modifier = "1.0"
			
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if obj is Fighter:
		host.visible_combo_count += 1
		flurrya1.scale_combo = false
		flurrya2.scale_combo = false
		
func explode_trin_with_my_mind():
	if false:
		print("grrrr raaahhh RAAAHHH *explodes you with my mind*")

func _exit():
	._exit()
	host.no_escape = 0
