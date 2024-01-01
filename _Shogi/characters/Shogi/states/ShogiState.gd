extends CharacterState

#class_name ShogiState

export var _c_Shogi_Data = 0
export var hitbox_register = {}
export var bounce_frame = -1

var last_vel = {}

func _enter():
	hitbox_register = {}
	#._enter()
	
func _add(hitbox, hits, ticks):
	hitbox_register[hitbox] = {"Hits":hits, "Ticks":ticks}
	
var x_speed_preserved = "0.25"
var speed = "25.0"
var BASE_JUMP_SPEED = "0.5"
var y_modifier = "0.7"
var x_modifier = "1.0"
const GLOBAL_JUMP_MODIFIER = "0.85"

func jump():
	var dir = host.get_opponent_dir_vec()
	if fixed.gt(dir.y, "-0.34"):
		dir.y = "-0.34"
		dir.x = fixed.mul(str(host.get_facing_int()), "0.94")
	dir = fixed.normalized_vec(dir.x, dir.y)
	dir.x = fixed.mul(dir.x, "100")
	dir.y = fixed.mul(dir.y, "100")
	
	#gwa gwa
	
	#host.end_throw_invulnerability()
	var vel = host.get_vel()
	host.set_grounded(false)
	host.set_vel(fixed.mul(vel.x, x_speed_preserved), "0")

	var force = xy_to_dir(dir.x, dir.y)
	var force_power = fixed.vec_mul(force.x, force.y, fixed.powu(fixed.vec_len(force.x, force.y), 2))
	force = Utils.fixed_vec2_string(fixed.div(fixed.add(force_power.x, force.x), "2"), fixed.div(fixed.add(force_power.y, force.y), "2"))
	force = fixed.vec_mul(force.x, force.y, fixed.add(speed, BASE_JUMP_SPEED))
	
	force.y = fixed.mul(force.y, y_modifier)
	force.x = fixed.mul(force.x, x_modifier)
	if (host.combo_count <= 0 or host.opponent.on_the_ground):
		force.y = fixed.mul(force.y, GLOBAL_JUMP_MODIFIER)
	host.apply_force(force.x, force.y)
	
func track(strength, keep_ground = true):
	var opp_pos = host.opponent.get_pos()
	var pos = host.get_pos()
	pos.x -= opp_pos.x
	pos.y -= opp_pos.y
	
	pos.x = -pos.x * host.get_facing_int()
	pos.y = -pos.y
		
	var dist = fixed.mul(host.obj_distance(host.opponent), strength)
	if fixed.gt(dist, "40.0"):
		dist = "40.0"
	#print(dist)
	var force = xy_to_dir(pos.x, pos.y, dist)
	if pos.y > 0:
		force.y = fixed.mul(force.y, "1.0")
	else:
		force.y = fixed.mul(force.y, "1.3")
		
	if keep_ground:
		if host.is_grounded():
			force.y = "0.0"
	
	host.apply_force_relative(force.x, force.y)
	
func _tick():
	._tick()
	
	var con1 = current_tick < bounce_frame
	var con2 = host.can_bounce == 1 and bounce_frame != 0
	var con3 = started_in_air
	var con4 = host.is_grounded()
	#print(str(con1) + ", " + str(con2) + ", " + str(con3) + ", " + str(con4))
	if con1 and con2 and con3 and con4:
		host.can_bounce = 2
		jump()
		#print("trying to jump")
		#host.dropped_this_turn = false
		"""
		if last_vel != {}:
			last_vel.y = fixed.mul(last_vel.y, "-1.0")
			host.set_vel(last_vel.x, last_vel.y)
			host.dropped_this_turn = false
		last_vel = host.get_vel()
		"""
	
	if hitbox_register != {}:
		for hitbox in hitbox_register:
			var consume_amount = hitbox_register[hitbox].Hits
			var tick_amount = hitbox_register[hitbox].Ticks
			#print(consume_amount)
			
			if hitbox.active:
				for o in host.objs_map.values():
					if(!is_instance_valid(o)):
						continue
					if(not o is BaseProjectile):
						continue
					if(hitbox.overlaps(o.hurtbox)):
						host.attempt_consume(o, consume_amount, tick_amount)

func _exit():
	if bounce_frame > 0:
		host.can_bounce = 0
	._exit()
