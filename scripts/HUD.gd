extends CanvasLayer

onready var actions = $Menu/Bottom/Actions
"""
Mostrar mensaje en pantalla según ganador.
"""
func _on_TurnQueue_we_have_a_winner(character: Character):
	$Label.text = character.MESSAGE
	$Label.show()


func _on_Player_clicked(player : Player):
	actions.player_clicked(player)

func _on_Actions_action_clicked(action):
	pass # Replace with function body.


func _on_attack_clicked():
	pass # Replace with function body.
