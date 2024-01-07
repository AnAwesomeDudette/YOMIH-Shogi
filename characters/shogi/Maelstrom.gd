extends "res://_Shogi/characters/shogi/states/RaidVariant.gd"


func is_usable():
	return .is_usable() and host.maelstrom_projectile == null
