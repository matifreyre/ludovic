extends HBoxContainer

onready var tween = $Tween
# Si no nos toca accionar se grisan las acciones
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	become_inactive() # Replace with function body.

func player_clicked(player):
	become_active()
	"""player.attack_requested()"""
	
func become_active():
	active = true
	var end_color = Color(1.0, 1.0, 1.0, 1.0)
	var start_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
func become_inactive():
	active = false
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)