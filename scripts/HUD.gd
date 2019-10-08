extends CanvasLayer


"""
Mostrar mensaje en pantalla según ganador.
"""
func _on_TurnQueue_we_have_a_winner(character: Character):
	$Label.text = character.MESSAGE
	$Label.show()