extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var _c_Raid_Variant = 0
export var nonconquer_super_cost = 0
export var conquer_super_cost = 0
export var raid_stack_cost = 0
export var conquer_raid_stack_cost = 0

func is_usable():
	if host.stance == "Conquer":
		super_level_ = conquer_super_cost
		return .is_usable() and host.raid_stacks >= conquer_raid_stack_cost
	else:
		super_level_ = nonconquer_super_cost
		return .is_usable() and host.raid_stacks >= raid_stack_cost 
			
func _frame_0_shared():
	._frame_0_shared()
	host.add_raid_stacks(-(conquer_raid_stack_cost if host.stance == "Conquer" else raid_stack_cost))


