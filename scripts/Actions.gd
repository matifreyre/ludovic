extends HBoxContainer

onready var tween = $Tween
# Si no nos toca accionar se grisan las acciones
var active = false
const inactive_color : Color = Color(1.0, 1.0, 1.0, 0.0)
const active_color : Color = Color(1.0, 1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	become_inactive() # Replace with function body.

func player_clicked(player):
	become_active()
	"""player.attack_requested()"""
	
func become_active():
	active = true
	tween.interpolate_property(self, "modulate", 
		inactive_color, active_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
func become_inactive():
	active = false
	tween.interpolate_property(self, "modulate", 
		active_color, inactive_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
