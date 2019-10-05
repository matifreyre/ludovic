extends Node2D

class_name TurnQueue


signal state_changed
signal we_have_a_winner(Character)

enum State { ACTIVE, PAUSED, GAME_OVER }

var active_character : Character
var state : int = State.ACTIVE


func play(characters : Array) -> void:
	while not state == State.GAME_OVER:
		match state:
			State.ACTIVE: # juega una ronda de turnos con todos los personajes
				for character in characters:
					active_character = character
					yield(active_character.play_turn(), "completed")
					if state == State.GAME_OVER:
						break	# Salir del for
			State.PAUSED: #espera a que la pausa se quite
				yield(self, "state_changed")


# Permite quitar la pausa del juego
func set_state(new_state) -> void:
	state = new_state
	emit_signal("state_changed")


# Se informa que el personaje alcanzó a otro 
func _on_character_hit(character : Character) -> void:
	if character == active_character:
		state = State.GAME_OVER
		emit_signal("we_have_a_winner", character)


# Una forma que se me ocurrió para "pausar" el juego, aunque como está sólo puede hacerse entre rondas.
# Es para tener una idea de estados posibles y no porque fuera necesario.
func _physics_process(delta :  float) -> void:
	if Input.is_action_just_pressed("pause"):
		match state:
			State.ACTIVE:
				state = State.PAUSED
			State.PAUSED:
				state = State.ACTIVE