extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

#func _frame_6():
	#host.global_hitlag(2)
	
func _frame_8():
	host.refresh_feints()
	host.opponent.refresh_feints()
	host.take_damage(20, 0, "0.0")
	#//I O U 60 bleeding damage
	host.take_damage(60, 0, "0.0")
	host.sacrifices += 1
	host.raid += 1
	
	var lag = 9
	if host.sacrifices > 4:
		host.take_damage(300, 300)
		lag = 9 + host.sacrifices
	host.global_hitlag(lag)
	
	var current_bar = max(host.supers_available, 1)
	var pointer = 3
	var base = str(pointer + 1 - current_bar)
	base = fixed.div(base, str(pointer))
	var mid = fixed.sub("1", base)
	mid = fixed.powu(mid, 2) if not mid == "0" else "0"
	var final = fixed.sub("1", mid)
	final = fixed.mul(final, str(host.MAX_SUPER_METER))
	
	var diff = 27
	var meter_gain = max(fixed.round(final) - diff, 1)
	#print(meter_gain)
	host.gain_super_meter(meter_gain)
	#print(host.super_meter)
