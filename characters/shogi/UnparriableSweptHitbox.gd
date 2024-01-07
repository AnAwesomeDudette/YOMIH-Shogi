tool

extends SweptHitbox


func hit(obj):
	var original_can_parry = false
	if obj is Fighter:
		if obj.current_state() is ParryState:
			original_can_parry = obj.current_state().can_parry
			obj.current_state().can_parry = false
		
	.hit(obj)
	if obj is Fighter:
		if obj.current_state() is ParryState:
			obj.current_state().can_parry = original_can_parry
