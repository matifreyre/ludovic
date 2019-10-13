extends "res://addons/gut/test.gd"

var Main: PackedScene = preload("res://scenes/Main.tscn")
var Player: = preload("res://scripts/Player.gd") 
var Board: = preload("res://scripts/Board.gd")
var main: Node
var player: Player
var board: Board 
var viewport_size: Vector2
const CELL_SIZE = Vector2(10,10)
const ORIGIN = Vector2(0,0)


func before_each(): 
	main = Main.instance()
	add_child(main)
	player = main.get_node("Characters/Player")
	board = main.get_node("RealBoard")
	board.cell_size = CELL_SIZE


""" Tests """

# No puedo hacer el yield o el move en un método auxiliar porque me arruina el test.

func test_player_starts_on_upper_left_corner() -> void:
	assert_eq(player.position, ORIGIN)
	assert_eq(player.get_coordinates(), ORIGIN)


func test_players_next_position_down_from_origin() -> void:
	self.move_player(Vector2.DOWN)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position.x, 0)
	assert_eq(player.position.y, CELL_SIZE.y) 


func test_players_next_position_right_from_origin() -> void:
	self.move_player(Vector2.RIGHT)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position.x, CELL_SIZE.x)
	assert_eq(player.position.y, 0)


func test_players_next_position_left_from_origin_is_origin() -> void:
	self.move_player(Vector2.LEFT)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position, ORIGIN)


func test_players_next_position_up_from_origin_is_origin() -> void:
	self.move_player(Vector2.UP)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position, ORIGIN)


func test_players_next_position_left_when_not_in_origin() -> void:
	player.position = board.map_to_world(Vector2(2,2))
	self.move_player(Vector2.LEFT)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position.x, 20 - CELL_SIZE.x)
	assert_eq(player.position.y, 20)


func test_players_next_position_up_when_not_in_origin() -> void:
	player.position = board.map_to_world(Vector2(2,2))
	self.move_player(Vector2.UP)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position.x, 20)
	assert_eq(player.position.y, 20 - CELL_SIZE.y)


func test_players_next_position_right_when_on_rightmost_cell() -> void:
	player.position = board.map_to_world(board.size)
	self.move_player(Vector2.RIGHT)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position, board.size * CELL_SIZE)


func test_players_next_position_down_when_on_lowest_cell() -> void:
	player.position = board.map_to_world(board.size)
	self.move_player(Vector2.DOWN)
	yield(yield_to(player, "character_moved", 1), YIELD)
	assert_eq(player.position, board.size * CELL_SIZE)


""" Auxiliares """


func move_player(direction):
	var next_position = board.request_move(player, direction)
	player.move(next_position)