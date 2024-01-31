extends CharacterState

func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	host.add_raid_stacks(4)
