extends Fighter

var no_escape = 0
var do_drop = false
var dropped_this_turn = false
var can_bounce = 0

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

func tick():
	.tick()
	if do_drop:
		apply_drop()
		do_drop = false

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
