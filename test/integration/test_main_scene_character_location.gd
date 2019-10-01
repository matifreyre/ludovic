extends "res://addons/gut/test.gd"

var main_scene = preload('res://scenes/Main.tscn')
var main


func before_each():
	main = main_scene.instance()


func test_player_starts_on_top_left_corner_of_board():
	self.add_child(main)
	var player = main.get_node("Player")
	assert_eq(player.coordinates, Vector2.ZERO)


func test_enemy_starts_on_bottom_right_corner_of_board_on_default_size():
	self.add_child(main)
	var enemy = main.get_node("Enemy")
	assert_eq(enemy.coordinates, self.get_bottom_right_coordinates())


func test_enemy_starts_on_bottom_right_corner_of_board_on_smaller_size():
	main.setup_board(2, 2)
	self.add_child(main)
	var enemy = main.get_node("Enemy")
	assert_eq(enemy.coordinates, self.get_bottom_right_coordinates())


func test_enemy_starts_on_bottom_right_corner_of_board_on_greater_size():
	main.setup_board(10, 8)
	self.add_child(main)
	var enemy = main.get_node("Enemy")
	assert_eq(enemy.coordinates, self.get_bottom_right_coordinates())


func get_bottom_right_coordinates():
	return Vector2(main.columns - 1, main.rows - 1)