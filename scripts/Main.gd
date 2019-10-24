extends Node2D


const DEFAULT_COLUMNS : = 8
const DEFAULT_ROWS : = 5

export(int, 2, 10) var columns : int = DEFAULT_COLUMNS
export(int, 2, 8) var rows : int = DEFAULT_ROWS

onready var board: Board = $Board
onready var player: Character = $Board/Player
onready var enemy: Character = $Board/Enemy


"""
Modificar configuración de columnas y filas.
"""
func setup_board(_columns : int = columns, _rows : int = rows) -> void:
	columns = _columns
	rows = _rows


"""
Inicializar juego.
"""
func _ready() -> void:
	self.initialize_board()
	self.initialize_enemy()
	$TurnQueue.play(board.characters)



"""
Ajuste del tablero configurado al tamaño de la pantalla.
"""
func adjust_viewport_to_board_config() -> void:
	pass
#	self.get_viewport().size = Vector2(columns, rows) * board.cell_size	


"""
Inicializar el tablero.
"""
func initialize_board() -> void:
	board.characters = [player, enemy]
	board.set_size(columns, rows)
	for character in board.characters:
		character.scale = Vector2.ONE / 2
	self.adjust_viewport_to_board_config()


"""
Inicializar el enemigo.
"""
func initialize_enemy() -> void:
	enemy.set_position_for(Vector2(columns - 1, rows - 1))
	enemy.initial_column = columns - 1
	enemy.initial_row = rows - 1


"""
Acción al obtener un ganador
"""
func _on_TurnQueue_we_have_a_winner(character : Character) -> void:
	character.raise()	# El ganador queda dibujado por encima del otro