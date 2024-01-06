extends "res://_Shogi/characters/shogi/states/RaidVariant.gd"

export var _c_drag = 0
export (bool) var drag = false
export (int) var offset_x = 0
export (int) var offset_y = 0
export (int) var end_on_tick = 1
export (int) var drag_strength = 10

var hit_opponent = false

onready var a1 = $A1
onready var a2 = $A2
onready var a3 = $A3
onready var a4 = $A4
onready var a5 = $A5
onready var b1 = $B1
onready var b2 = $B2
onready var b3 = $B3
onready var b4 = $B4
onready var c1 = $C1
onready var c2 = $C2
onready var c3 = $C3
onready var c4 = $C4
onready var c5 = $C5
onready var c6 = $C6
onready var d1 = $D1
onready var d2 = $D2
onready var d3 = $D3
onready var d4 = $D4

func _enter():
	._enter()
	host.TIMEFREEZE = true
	_add(a1, 1, 1); _add(a2, 1, 1); _add(a3, 1, 1); _add(a4, 1, 1); _add(a5, 1, 1);
	_add(b1, 1, 1); _add(b2, 1, 1); _add(b3, 1, 1); _add(b4, 1, 1);
	_add(c1, 1, 1); _add(c2, 1, 1); _add(c3, 1, 1); _add(c4, 1, 1); _add(c5, 1, 1); _add(c6, 1, 1);
	_add(d1, 1, 1); _add(d2, 1, 1); _add(d3, 1, 1); _add(d4, 1, 1);
	
	_add_f(a1, 5); _add_f(a2, 5); _add_f(a3, 5); _add_f(a4, 5); _add_f(a5, 5); 
	_add_f(b1, 5); _add_f(b2, 5); _add_f(b3, 5); _add_f(b4, 5); 
	_add_f(c1, 5); _add_f(c2, 5); _add_f(c3, 5); _add_f(c4, 5); _add_f(c5, 5); _add_f(c6, 5); 
	_add_f(d1, 5); _add_f(d2, 5); _add_f(d3, 5); _add_f(d4, 5); 
	hit_opponent = false

func _frame_10():
	host.TIMEFREEZE = false

func _frame_22():
	host.global_hitlag(7)


func _on_hit_something(obj, _hitbox):
	._on_hit_something(obj, _hitbox)
	
	var valid_hitboxes = {
		a1:true,
		a2:true,
		a3:true,
		a4:true,
		a5:true,
		b1:true,
		b2:true,
		b3:true,
		b4:true
	}
	#if _hitbox is a1 
	#if true:
	if valid_hitboxes.has(_hitbox):
		var pos = host.get_pos()
		var opos = host.opponent.get_pos()
		
		var vect = Vector2(opos.x - pos.x + offset_x * host.get_facing_int(), opos.y - pos.y + offset_y)
		var vec_x = fixed.round(fixed.div(str(vect.x), "50.0"))
		var vec_y = fixed.round(fixed.div(str(vect.y), "50.0"))
		host.opponent.set_vel(vec_x, vec_y)
		
		#print(vect)
		
		#var dist = host.distance_to(host.opponent)
		#var dist
		
		#print(pos)
		#print(opos)
		
		#host.opponent.set_vel(0, 0)
		#host.opponent.move_directly(str((pos.x + (offset_x * host.get_facing_int()) - opos.x) / drag_strength), str((pos.y - (offset_y + 18) - opos.y) / drag_strength))
		
			
func _exit():
	host.TIMEFREEZE = false
