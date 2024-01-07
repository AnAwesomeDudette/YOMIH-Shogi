extends BaseProjectile


func on_got_blocked():
	current_state().returning = true
