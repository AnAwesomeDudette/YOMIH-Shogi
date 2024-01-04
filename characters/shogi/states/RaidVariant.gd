extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

export var _c_Raid_Variant = 0
export var super_cost = 0
export var conquer_super_cost = 0
export var raid_stack_cost = 0
export var conquer_raid_stack_cost = 0

func is_usable():
	if host.stance == "Conquer":
		return .is_usable() and host.supers_available >= conquer_super_cost and host.raid_stacks >= conquer_raid_stack_cost 
	else:
		return .is_usable() and host.supers_available >= super_cost and host.raid_stacks >= raid_stack_cost 
			
func _frame_0_shared():
		for i in range(conquer_super_cost if host.stance == "Conquer" else super_cost):
			host.use_super_bar()
		host.add_raid_stacks(-(conquer_raid_stack_cost if host.stance == "Conquer" else raid_stack_cost))
