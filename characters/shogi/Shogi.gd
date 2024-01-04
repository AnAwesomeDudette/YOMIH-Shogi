extends Fighter

var no_escape = 0
var do_drop = false
var dropped_this_turn = false
var can_bounce = 0
var current_conquer_tier = 0
var armor_hits_remaining = 0
var sacrifices = 0 #7 uses
var raid_stacks = 0
var dedication = {"x":0, "y":0}
var dedication_delay = -1
var got_hit = false # whether Shogi was hit this tick
var damage_multiplier = 1
var queue_damage_multiplier = 1
var reset_damage_multiplier = false
var dedication_stacks = 1
var super_until_dedication = MAX_SUPER_METER

func add_raid_stacks(stacks):
	raid_stacks += stacks
	raid_stacks = clamp(raid_stacks, 0, 4)

func init(pos = null):
	.init(pos)
	HOLD_RESTARTS.append("Walk")
	HOLD_RESTARTS.append("Shuffle")

func _on_state_exited(state):
	._on_state_exited(state)
	if previous_state() != null:
		armor_hits_remaining = 0


func on_state_interruptable(state = null):
	.on_state_interruptable(state)
	armor_hits_remaining = 0

func change_stance_to(stance):
	.change_stance_to(stance)
	if stance == "Conquer":
		queue_damage_multiplier = 0.8
	else:
		queue_damage_multiplier = 1

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

func incr_combo(scale = true, projectile = false, force = false, combo_scale_amount = 1):
	.incr_combo(scale, projectile, force, combo_scale_amount)
	if combo_count == 3 or combo_count == 6 or combo_count == 9:
		add_raid_stacks(1)
		
func on_got_hit_by_fighter():
	if armor_hits_remaining > 0:
		got_hit = true
	.on_got_hit_by_fighter()

func on_got_hit():
	if has_armor():
		hitlag_ticks += 1
	.on_got_hit()

func tick():
	.tick()
	if (stance == "Conquer"):
		var old_super_meter = super_meter + (MAX_SUPER_METER * supers_available) 
		use_super_meter(MAX_SUPER_METER/25)
		super_until_dedication -= old_super_meter - (super_meter + (MAX_SUPER_METER * supers_available))
		if (super_until_dedication <= 0):
			super_until_dedication += MAX_SUPER_METER
			dedication_stacks += 1
	if reset_damage_multiplier:
		damage_multiplier = 1
	if queue_damage_multiplier < damage_multiplier:
		damage_multiplier = queue_damage_multiplier
	if dedication_delay > 0:
		dedication_delay -= 1
		if dedication_delay == 0:
			dedication_delay = -1
			#if dedication != {"x":0, "y":0}:
			#print("Applying...")
			set_vel(get_vel().x, "0.0");
			apply_dedication(dedication.x, dedication.y)
	
	if do_drop:
		apply_drop()
		do_drop = false
		
	if got_hit:
		armor_hits_remaining -= 1
		got_hit = false

func apply_dedication(x, y):
	
	var mult = fixed.div("100", str(max_air_speed))
	var apply_x = fixed.div(str(x), mult)
	var apply_y = fixed.div(str(y), mult)
	
#	var x_mod = "1.5"
#	var y_mod = "1.5"
#	apply_x = fixed.mul(apply_x, x_mod)
#	apply_y = fixed.mul(apply_y, y_mod)
	
	if (sign(opponent.data.object_data.position_x - data.object_data.position_x) != sign(x)) and not opponent.is_in_hurt_state():
		var penalty = int(fixed.round(fixed.abs(fixed.mul(apply_x, "2"))))
		add_penalty(penalty)
	apply_x = fixed.round(apply_x)
	
	if (int(fixed.round(apply_y)) > 0) and not opponent.is_in_hurt_state():
		apply_y = fixed.round(fixed.mul(apply_y, "0.8"))
	else:
		apply_y = fixed.round(fixed.mul(apply_y, "1.0"))
	
	apply_force(apply_x, apply_y)
	#print("Applied!")

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
	
func has_armor():
	return (armor_hits_remaining > 0  or (stance == "Conquer" and has_super_meter())) and not (current_state() is CharacterHurtState)
	
func take_damage(damage:int, minimum = 0, meter_gain_modifier = "1.0", combo_scaling_offset = 0, damage_taken_meter_gain_modifier = "1.0"):
	damage *= damage_multiplier
	.take_damage(damage, minimum ,meter_gain_modifier, combo_scaling_offset, damage_taken_meter_gain_modifier)

func has_dedication():
	return dedication_stacks >= 1
