extends CharacterState

#class_name ShogiState

export var _c_Shogi_Data = 0
export var hitbox_register = {}
export var hitbox_frame = {}
export var min_bounce_frame = -1
export var bounce_frame = -1
export var y_modifier = "0.7"
export var x_modifier = "1.0"
export var y_cap = "1.0"
export var can_conquer = false
export var is_raid_variant = false
export (String) var opposite_variant = null
export var conquer_1_frames = 4
export var conquer_2_frames = 5
export var conquer_3_frames = 7

export (PackedScene) var shogi_hit_particle
var damage_multiplier = 1
var original_hitbox_plus_frames = {}
var original_fallback_state = fallback_state
var end_with_awaken = false
var armor_hits_to_give = 0
var armor_timer = 3


func is_usable():
	if (host.stance == "Conquer") and is_raid_variant == false:
		if (host.state_machine.get_state(opposite_variant)):
			if (host.state_machine.get_state(opposite_variant).is_usable()):
				return false
	return .is_usable()

func init():
	.init()
	for hitbox in all_hitbox_nodes:
		original_hitbox_plus_frames[hitbox] = hitbox.plus_frames
		#//this is so strange
		#//weirdopilled, even
		#//but it should workies -

var last_vel = {}

var windup = -1

func add_plus_frames(frames): 
	for hitbox in all_hitbox_nodes:
		hitbox.plus_frames += frames
		
func _add(hitbox, hits, ticks):
	hitbox_register[hitbox] = {"Hits":hits, "Ticks":ticks}
	
func _add_f(hitbox, frame):
	hitbox_frame[hitbox] = frame

func conquer_tier_1():
	windup = conquer_1_frames
	add_plus_frames(3)
	armor_hits_to_give = 1

func conquer_tier_2():
	windup = conquer_2_frames
	add_plus_frames(3)
	armor_hits_to_give = 2

func conquer_tier_3():
	windup = conquer_3_frames
	add_plus_frames(3)
	end_with_awaken = true
	fallback_state = "Awaken"
	armor_hits_to_give = 4
	

func _enter():
	fallback_state = original_fallback_state
	end_with_awaken = false
	armor_hits_to_give = 0
	armor_timer = 1 if host.initiative else 3
	for hitbox in all_hitbox_nodes:
		hitbox.plus_frames = original_hitbox_plus_frames[hitbox]
	hitbox_register = {}
	hitbox_frame = {}
	if can_conquer:
		if host.current_conquer_tier == 1:
			conquer_tier_1()
		if host.current_conquer_tier == 2:
			conquer_tier_2()
		if host.current_conquer_tier == 3:
			conquer_tier_3()
	
	._enter()
	
var x_speed_preserved = "0.25"
var speed = "25.0"
var BASE_JUMP_SPEED = "0.5"
const GLOBAL_JUMP_MODIFIER = "0.85"

func jump():
	var dir = host.get_opponent_dir_vec()
	if fixed.gt(dir.y, "-0.34"):
		dir.y = "-0.34"
		dir.x = fixed.mul(str(host.get_facing_int()), "0.94")
	var cap = fixed.mul(y_cap, "-1.0")
	if fixed.lt(dir.y, cap):
		dir.y = cap
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
	if windup < 0:
		._tick()
		
func _tick_after():
	if windup < 0:
		._tick_after()



		
func _tick_shared():
		
	armor_timer -= 1
	if (armor_timer == 0):
		host.armor_hits_remaining = armor_hits_to_give
	if windup >= 0:
		host.queue_damage_multiplier = 0.95
		if current_tick == -1:
			if spawn_particle_on_enter and particle_scene:
				var pos = particle_position
				pos.x *= host.get_facing_int()
				spawn_particle_relative(particle_scene, pos, Vector2.RIGHT * host.get_facing_int())
			apply_enter_force()
		current_tick = 0
		
		windup -= 1

		update_sprite_frame()
			
		if apply_fric:
			host.apply_fric()
		if apply_grav:
			host.apply_grav()
		if apply_custom_x_fric:
			host.apply_x_fric(custom_x_fric)
		if apply_custom_y_fric:
			host.apply_y_fric(custom_y_fric)
		if apply_custom_grav:
			host.apply_grav_custom(custom_grav, custom_grav_max_fall_speed)
		if apply_forces:
			if apply_forces_no_limit:
				host.apply_forces_no_limit()
			
			elif apply_custom_limits:
				if host.is_grounded():
					host.limit_x_speed(custom_max_ground_speed)
				else :
					host.limit_x_speed(custom_max_air_speed)
				host.apply_forces_no_limit()
			else :
				host.apply_forces()
		if (windup >= 0):
			return
	
	host.reset_damage_multiplier = true
	._tick_shared()
	
	var con1 = current_tick < bounce_frame and current_tick > min_bounce_frame
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

	if (current_tick == iasa_at and end_with_awaken):
		next_state_on_hold = false
		queue_state_change("Awaken")


"""
func _on_hit_something(obj, _hitbox):
	._on_hit_something(obj, _hitbox)
	host.spawn_particle_effect(preload("res://_Neru/Characters/Neru/particles/Small Slash.tscn"), host.opponent.position)
"""

func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if shogi_hit_particle:
		var dir = hitbox.get_dir_float(true)
		var location = hitbox.get_overlap_center_float(obj.hurtbox)
		var location_alt = host.opponent.get_pos_visual()
		if hitbox.grounded_hit_state is String and hitbox.grounded_hit_state == "HurtGrounded" and obj.is_grounded():
				dir.y *= 0
		var par = host._spawn_particle_effect(shogi_hit_particle, location, dir)
		
		
		if not host.is_ghost:
			par.material = host.sprite.material
		"""
			# par.get_material().set_shader_param("is_particle", true)
			for child_node in par.get_children():
				if child_node is CPUParticles2D:
					child_node.set_color_ramp(preload("res://_Shogi/characters/shogi/particles/ShogiHitGradient.tres"))
		"""

		var frame = host.randi_range(0, 5)
		if hitbox_frame.has(hitbox):
			frame = hitbox_frame[hitbox]
		par.get_children()[2].texture.set_region(Rect2(frame*128, 0, 128, 128)) #//I LOVE CODE
		
		#host.spawn_particle_effect(shogi_hit_particle, hitbox.get_overlap_center_float(obj.hurtbox))#, dir)
		#host.spawn_particle_effect(preload("res://_Neru/Characters/Neru/particles/Small Slash.tscn"), host.opponent.position, dir)
		#//print("Should spawn hit particle!")


func _exit():
	if bounce_frame > 0:
		host.can_bounce = 0
	._exit()
