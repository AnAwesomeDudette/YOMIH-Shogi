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
	hit_opponent = false
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
	if hit_opponent and current_tick >= 4 and current_tick <= 17:
		track("0.03")
	#host.apply_forces_no_limit()
	if fixed.lt(host.get_vel().y, "-7"):
		host.set_vel(host.get_vel().x, "-7")
		
	if hit_opponent == true and drag:
		if current_tick < end_on_tick:
			var pos = host.get_pos()
			var opos = host.opponent.get_pos()

			host.opponent.set_vel(0, 0)
			host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))
	
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
	track("0.03")
			
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
		hit_opponent = true
		host.visible_combo_count += 1
		flurrya1.scale_combo = false
		flurrya2.scale_combo = false
		
func on_attack_blocked():
	track("0.03")
		
func explode_trin_with_my_mind():
	if false:
		print("grrrr raaahhh RAAAHHH *explodes you with my mind*")

func _exit():
	._exit()
	host.no_escape = 0
