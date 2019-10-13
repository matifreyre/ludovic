extends "res://addons/gut/test.gd"

var main_scene : = preload('res://scenes/Main.tscn')
var main : Node


func before_each() -> void:
	main = main_scene.instance()


""" Tests """


func test_player_starts_on_top_left_corner_of_board() -> void:
	self.add_child(main)
	var player = main.get_node("Characters/Player")
	assert_eq(player.get_coordinates(), Vector2.ZERO)


func test_enemy_starts_on_bottom_right_corner_of_board_on_default_size() -> void:
	self.add_child(main)
	var enemy = main.get_node("Characters/Enemy")
	assert_eq(enemy.get_coordinates(), self.get_bottom_right_coordinates())


func test_enemy_starts_on_bottom_right_corner_of_board_on_smaller_size() -> void:
	main.setup_board(2, 2)
	self.add_child(main)
	var enemy = main.get_node("Characters/Enemy")
	assert_eq(enemy.get_coordinates(), self.get_bottom_right_coordinates())


func test_enemy_starts_on_bottom_right_corner_of_board_on_larger_size() -> void:
	main.setup_board(10, 8)
	self.add_child(main)
	var enemy = main.get_node("Characters/Enemy")
	assert_eq(enemy.get_coordinates(), self.get_bottom_right_coordinates())


""" Auxiliares """


func get_bottom_right_coordinates() -> Vector2:
	return Vector2(main.columns - 1, main.rows - 1)