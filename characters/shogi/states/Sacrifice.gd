extends "res://_Shogi/characters/shogi/states/ShogiState.gd"

var SACRIFICE_PARTICLES = preload("res://_Shogi/characters/shogi/particles/ShogiHit.tscn")
var SACRIFICE_PARTICLES_POS = Vector2(0, -18)

#func _frame_6():
	#host.global_hitlag(2)

func _frame_8():
	var pos = SACRIFICE_PARTICLES_POS
	SACRIFICE_PARTICLES_POS.x *= host.get_facing_int()
	var par = host._spawn_particle_effect(SACRIFICE_PARTICLES, host.get_pos_visual() + SACRIFICE_PARTICLES_POS, Vector2(host.get_facing_int(), 0))
	
	par.material = host.sprite.material

	
	host.refresh_feints()
	host.opponent.refresh_feints()
	host.take_damage(20, 0, "0.0")
	#//I O U 60 bleeding damage
	host.take_damage(60, 0, "0.0")
	host.sacrifices += 1
	host.add_raid_stacks(1)
	
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
