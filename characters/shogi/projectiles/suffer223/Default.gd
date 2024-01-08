extends ObjectState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var homing_start_tick = 3
export (int) var homing_end_tick = 7
var drag_strength = 10
var returning = false
var should_pull = false
export (int) var pull_frames = 20

func _enter():
	host.creator.maelstrom_projectile = self

func _frame_0():
	host.set_grounded(false)


func _tick_shared():
	._tick_shared()

func _tick():
	._tick()
	if host.creator.current_state() is CharacterHurtState:
		returning = true
	if current_tick >= 150:
		returning = true
	host.update_grounded()
	if host.creator.opponent.invulnerable or host.creator.opponent.projectile_invulnerable:
		returning = false
	if should_pull == true and pull_frames > 0 and not (host.creator.opponent.current_state() is CharacterHurtState):
		pull_frames -= 1
		var pos = host.get_pos()
		var opos = host.creator.opponent.get_pos()

		host.creator.opponent.set_vel(0, 0)
		host.creator.opponent.move_directly(str((pos.x - opos.x) / drag_strength), str((pos.y - opos.y) / drag_strength))
	
	if current_tick <= homing_end_tick and current_tick >= homing_start_tick and not returning:
		track("0.03", host.creator.opponent.get_pos())
	elif returning:
		track("0.03", host.creator.get_pos())
	if host.collision_box.overlaps(host.creator.collision_box) and returning:
		fizzle()


func fizzle():
	host.creator.maelstrom_projectile = null
	host.disable()
	terminate_hitboxes()
	
func track(strength, opp_pos):
	var pos = host.get_pos()
	pos.x -= opp_pos.x
	pos.y -= opp_pos.y

	#print(pos.y)
	
	
	pos.x = -pos.x * host.get_facing_int()
	pos.y = -pos.y
		
	var dist = fixed.mul(host.obj_distance(host.creator.opponent), strength)
	if fixed.gt(dist, "40.0"):
		dist = "40.0"
	#print(dist)
	var force = xy_to_dir(pos.x, pos.y, dist)
	if pos.y > 0:
		force.y = fixed.mul(force.y, "1.0")
	else:
		force.y = fixed.mul(force.y, "1.3")
		

	
	host.apply_force_relative(force.x, force.y)

func _on_hit_something(obj, hitbox):
	if obj == host.creator.opponent:
		returning = true
		should_pull = true
