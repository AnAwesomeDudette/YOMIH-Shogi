extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var _c_drag = 0
export (bool) var drag = false
export (int) var offset_x = 0
export (int) var offset_y = 0
export (int) var end_on_tick = 1
export (int) var drag_strength = 10

var hit_opponent = false

func _enter():
	._enter()

	hit_opponent = false
	
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
	if hit_opponent == true and drag:
		if current_tick < end_on_tick:
			var pos = host.get_pos()
			var opos = host.opponent.get_pos()

			host.opponent.set_vel(0, 0)
			host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))

func _on_hit_something(obj, _hitbox):
	._on_hit_something(obj, _hitbox)
	if current_tick < end_on_tick:
		if obj == host.opponent:
			hit_opponent = true
