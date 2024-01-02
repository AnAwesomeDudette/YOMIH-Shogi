extends Fighter

var no_escape = 0
var do_drop = false
var dropped_this_turn = false
var can_bounce = 0
var current_conquer_tier = 0
var sacrifices = 0 #7 uses
var raid = 0
var dedication = {"x":0, "y":0}
var dedication_delay = -1

func init(pos = null):
	.init(pos)
	HOLD_RESTARTS.append("Walk")

func on_got_parried():
	.on_got_parried()
	if no_escape > 0:
		hitlag_ticks += no_escape
		no_escape = 0

func on_got_blocked():
	.on_got_blocked()
	if current_state().has_method("on_got_blocked"):
		current_state().on_got_blocked()
		
func on_attack_blocked():
	.on_attack_blocked()
	if current_state().has_method("on_attack_blocked"):
		current_state().on_attack_blocked()

func process_extra(extra):
	.process_extra(extra)
	
	var can_drop = true
	if busy_interrupt:
		can_drop = false
			
	if extra.has("drop_enabled") and extra.drop_enabled and can_drop:
		do_drop = true
	if extra.has("conquer_tier"):
		current_conquer_tier = extra.conquer_tier

func tick():
	.tick()
	
	if dedication_delay > 0:
		dedication_delay -= 1
		if dedication_delay == 0:
			dedication_delay = -1
			#if dedication != {"x":0, "y":0}:
			apply_dedication(dedication.x, dedication.y)
	
	if do_drop:
		apply_drop()
		do_drop = false

func apply_dedication(x, y):
	
	var mult = fixed.div("100", str(max_air_speed))
	var apply_x = fixed.div(str(x * get_facing_int()), mult)
	var apply_y = fixed.div(str(y), mult)
	
	var x_mod = "1.5"
	var y_mod = "1.5"
	apply_x = fixed.mul(apply_x, x_mod)
	apply_y = fixed.mul(apply_y, y_mod)
	
	if (sign(opponent.data.object_data.position_x - data.object_data.position_x) != sign(x)) and not opponent.is_in_hurt_state():
		var penalty = int(fixed.round(fixed.abs(fixed.mul(apply_x, "2"))))
		add_penalty(penalty)
		apply_x = fixed.round(apply_x)
	else:
		apply_x = fixed.round(apply_x)
		
	if (int(fixed.round(apply_y)) > 0) and not opponent.is_in_hurt_state():
		apply_y = fixed.round(fixed.mul(apply_y, "0.8"))
	else:
		apply_y = fixed.round(apply_y)
	
	apply_force_relative(apply_x, apply_y)

func apply_drop():
	apply_force_relative("0.0", "10.0")
	dropped_this_turn = true
	can_bounce = 1

func turn_start_effects():
	dropped_this_turn = false

func attempt_consume(obj, hits = 1, ticks = 0):
	obj.hitlag_ticks += ticks
	if obj.current_state().get("num_hits"):
		if obj.current_state().num_hits - 1 != -1:
			obj.current_state().num_hits -= 1
			
			var can_state_fizzle = false
			if obj.get("state_machine"):
				if obj.state_machine.get("state"):
					if obj.state_machine.state.has_method("fizzle"):
						can_state_fizzle = true
			if can_state_fizzle:
				obj.state_machine.state.fizzle()
			elif obj.has_method("fizzle"):
				obj.fizzle()
	#elif true:
	#	pass

#fast fall bounce thingymajigoo
