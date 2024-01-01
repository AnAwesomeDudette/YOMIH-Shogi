extends "res://_Shogi_Git/YOMIH-Shogi/_Shogi/characters/Shogi/states/ShogiState.gd"

onready var hitbox1 = $SHitbox1
onready var hitbox2 = $SHitbox2
onready var catch = $Catch

var halt = false

func _enter():
	._enter()
	
	_add(hitbox1, 1, 0)
	_add(hitbox2, 1, 0)
	_add(catch, 1, 0)
	
	hitbox1.activated = true
	hitbox2.activated = true
	catch.activated = false
	
	halt = false
	
	catch.di_modifier = "0.0"
	catch.sdi_modifier = "0.0"
	catch.dir_x = "0.0"
	catch.dir_y = "0.0"
	catch.knockback = "5.0"
	
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
	var y_dist = str(host.obj_local_pos(host.opponent).y)
	#print(y_dist)
	if not halt:
		catch.dir_x = host.get_vel().x
		catch.dir_y = fixed.mul(y_dist, "1")#host.get_vel().y

func _frame_16():
	catch.di_modifier = "1.0"
	catch.sdi_modifier = "0.8"
	catch.dir_x = "-1.0"
	catch.dir_y = "-0.25"
	catch.knockback = "9.0"
	halt = true

func on_attack_blocked():
	hitbox1.activated = false
	hitbox2.activated = false
	catch.activated = true

func _on_hit_something(obj, _hitbox):
	._on_hit_something(obj, _hitbox)
	if obj is Fighter:
		if _hitbox == catch:
			host.visible_combo_count += 1
			#print("Hitting the right hitbox")
		else:
			hitbox1.activated = false
			hitbox2.activated = false
			catch.activated = true