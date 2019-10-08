extends CanvasLayer


func _on_TurnQueue_we_have_a_winner(character: Character):
	$Label.text = character.MESSAGE
	$Label.show()