extends Node2D


class_name TurnQueue


func play(characters : Array):
	while(true):
		for active_character in characters:
			yield(active_character.play_turn(), "completed")