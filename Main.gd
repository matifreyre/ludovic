extends Node2D

func _ready():
	$TurnQueue.play([$Player, $Enemy])