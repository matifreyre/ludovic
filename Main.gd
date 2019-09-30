extends Node2D

export var columns : int = 8
export var rows : int = 5

func _ready():
	var characters = [$Player, $Enemy] 
	$TurnQueue.play(characters) 