extends Node2D

class_name TurnQueue

#onready var characters = self.get_characters()

func play(characters : Array):
	while(true):
		var active_character = characters.pop_front()
		yield(active_character.play_turn(), "completed")
		characters.push_back(active_character)
	 
#func get_characters() -> Array:  
##	return $Characters.get_children()
#	return [self.get_parent().$Player] 