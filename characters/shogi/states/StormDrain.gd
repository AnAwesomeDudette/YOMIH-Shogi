extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

onready var hitbox1 = $SHitbox1
onready var hitbox2 = $SHitbox2
onready var catch = $Catch
export var _c_drag = 0
export (bool) var drag = false
export (int) var offset_x = 0
export (int) var offset_y = 0
export (int) var end_on_tick = 1
export (int) var drag_strength = 10

var halt = false
var hit_opponent = false

func enable_hitbox(can_catch = false):
	if can_catch == false:
		hitbox1.hits_vs_grounded = true
		hitbox1.hits_vs_aerial = true
		hitbox1.can_draw = true
		
		hitbox2.hits_vs_grounded = true
		hitbox2.hits_vs_aerial = true
		hitbox2.can_draw = true
		
		catch.hits_vs_grounded = false
		catch.hits_vs_aerial = false
		catch.can_draw = false
		if catch.whiff_sound and catch.whiff_sound_player:
			catch.whiff_sound_player.volume_db = -100
	else:
		hitbox1.hits_vs_grounded = false
		hitbox1.hits_vs_aerial = false
		hitbox1.can_draw = false
		
		hitbox2.hits_vs_grounded = false
		hitbox2.hits_vs_aerial = false
		hitbox2.can_draw = false
		
		catch.hits_vs_grounded = true
		catch.hits_vs_aerial = true
		catch.can_draw = true
		if catch.whiff_sound and catch.whiff_sound_player:
			catch.whiff_sound_player.volume_db = -8

func _enter():
	hit_opponent = false
	._enter()


	_add(hitbox1, 1, 0)
	_add(hitbox2, 1, 0)
	_add(catch, 1, 0)
	
	enable_hitbox()
	
	halt = false
	
	catch.di_modifier = "0.0"
	catch.sdi_modifier = "0.0"
	catch.dir_x = "0.0"
	catch.dir_y = "0.0"
	catch.knockback = "5.0"
	

	
	hit_opponent = false
	if host.reverse_state:
		hitbox1.guard_break = false
		hitbox2.guard_break = false
		catch.guard_break = false
		enter_force_speed = "12.5"
	else:
		hitbox1.guard_break = true
		hitbox2.guard_break = true
		catch.guard_break = true
		enter_force_speed = "25.0"
	._enter()
	
func _frame_0():
	host.play_sound("Super2")
	
	"""
	hitbox1.x = -48
	hitbox1.y = -17
	hitbox1.width = 16
	hitbox1.height = 16
	hitbox1.to_x = 23
	hitbox1.to_y = -8
	
	hitbox2.x = 25
	hitbox2.y = -12
	hitbox2.width = 16
	hitbox2.height = 16
	hitbox2.to_x = 23
	hitbox2.to_y = -8
	"""
	

func _frame_4():
	host.start_projectile_invulnerability()
	
func _frame_13():
	host.end_projectile_invulnerability()
	
func _tick():
	._tick()
	host.apply_forces_no_limit()
	if hit_opponent == true and drag:
		if current_tick < end_on_tick:
			var pos = host.get_pos()
			var opos = host.opponent.get_pos()

			host.opponent.set_vel(0, 0)
			host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))

func _frame_16():
	catch.di_modifier = "1.0"
	catch.sdi_modifier = "0.8"
	catch.dir_x = "-1.0"
	catch.dir_y = "-0.25"
	catch.knockback = "9.0"
	halt = true
	
func on_attack_blocked():
	enable_hitbox(true)
	
func _on_hit_something(obj, _hitbox):
	._on_hit_something(obj, _hitbox)
	if obj is Fighter:
		if _hitbox == catch:
			host.visible_combo_count += 1
			#print("Hitting the right hitbox")
		else:
			enable_hitbox(true)
			#print(catch.activated)
			
	if current_tick < end_on_tick:
		if obj == host.opponent:
			hit_opponent = true
