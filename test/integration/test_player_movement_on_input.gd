#extends "res://addons/gut/test.gd"
#
#var Player: PackedScene = preload("res://scenes/characters/Player.tscn")
#var Board: PackedScene = preload("res://scenes/Board.tscn")
#var player: Node = Player.instance()
#var board: Node = Board.instance()
#
#func before_each() -> void:
#	self.add_child(player) 
#
#
#""" Tests """
#
#
#func test_cell_size_is_squared() -> void:
#	assert_eq(board.cell_size.x, board.cell_size.y)
#	assert_gt(board.cell_size, Vector2(0,0))