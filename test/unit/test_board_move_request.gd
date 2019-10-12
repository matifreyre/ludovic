extends "res://addons/gut/test.gd"


var Board: = preload("res://scripts/Board.gd")
var Character: = preload("res://scripts/Character.gd")
var board: Board
var character: Character
const CELL_SIZE : = Vector2(128, 128)


class MockCharacter:
	extends Character
	
	var type = EMPTY
	
	var coordinates: = Vector2.ZERO setget set_coordinates, get_coordinates
	
	func set_coordinates(_coordinates):
		coordinates = _coordinates
		position = coordinates * CELL_SIZE
	func get_coordinates():
		return coordinates


func before_each() -> void:
	board = Board.new()
	board.set_size(3, 3)
	board.cell_size = CELL_SIZE
	character = MockCharacter.new()



""" Tests """


func test_top_left_corner_invalid_moves() -> void:
	assert_null(board.request_move(character, Vector2.UP))
	assert_null(board.request_move(character, Vector2.LEFT))


func test_top_left_corner_valid_moves() -> void:
	assert_eq(board.request_move(character, Vector2.DOWN), CELL_SIZE * Vector2.DOWN)
	assert_eq(board.request_move(character, Vector2.RIGHT), CELL_SIZE * Vector2.RIGHT)


func test_bottom_right_corner_valid_moves() -> void:
	character.coordinates = board.size
	var pos = character.position
	assert_eq(board.request_move(character, Vector2.UP), pos + CELL_SIZE * Vector2.UP)
	assert_eq(board.request_move(character, Vector2.LEFT), pos + CELL_SIZE * Vector2.LEFT)


func test_bottom_right_corner_invalid_moves() -> void:
	character.coordinates = board.size
	assert_null(board.request_move(character, Vector2.DOWN))
	assert_null(board.request_move(character, Vector2.RIGHT))


func test_center_valid_moves() -> void:
	character.coordinates = Vector2(1, 1)
	var pos = character.position
	assert_eq(board.request_move(character, Vector2.DOWN), pos + CELL_SIZE * Vector2.DOWN)
	assert_eq(board.request_move(character, Vector2.RIGHT), pos + CELL_SIZE * Vector2.RIGHT)
	assert_eq(board.request_move(character, Vector2.UP), pos + CELL_SIZE * Vector2.UP)
	assert_eq(board.request_move(character, Vector2.LEFT), pos + CELL_SIZE * Vector2.LEFT)
