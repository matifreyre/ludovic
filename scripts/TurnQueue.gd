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
# Así como está no termina el juego si tirás al jugador en la 
# misma celda en la que está el enemigo, pero se evita que termine
# sólo por hoverear
func _on_character_hit(character : Character) -> void:
	if character == active_character && !character.is_grabbed:
		self.terminate()
		emit_signal("we_have_a_winner", character)


func terminate() -> void:
	state = State.GAME_OVER
	$BackgroundMusic.stop()
	$GameOverSound.play()


"""
Una forma que se me ocurrió para "pausar" el juego, aunque como está sólo puede hacerse entre rondas.
Es para tener una idea de estados posibles y no porque fuera necesario. 
Hay un mecanismo built-in para pausar el juego, se puede investigar.
"""
func _physics_process(delta :  float) -> void:
	if Input.is_action_just_pressed("pause"):
		match state:
			State.ACTIVE:
				self.set_state(State.PAUSED)
			State.PAUSED:
				self.set_state(State.ACTIVE)