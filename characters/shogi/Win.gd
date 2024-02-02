extends CharacterState



func _frame_0():
	$"./Dialogue".show()
	$"./Dialogue".text = host.Dialogue.GetLine(host.getOpponentName(), "Win", Network.pid_to_username(host.opponent.id))
