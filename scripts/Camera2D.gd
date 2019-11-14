extends Camera2D


export(float, 0.0, 10.0) var shake_amount = 3.0
export(float, 0.0, 2.0) var shake_time = 0.3

onready var shake_timer: Timer = $ShakeTimer


"""
Mientras el timer está corriendo, vibra.
"""
func _process(delta: float) -> void: 
	if not shake_timer.is_stopped():
		self.shake()	


func _ready() -> void:
	shake_timer.wait_time = shake_time


"""
Iniciar la vibración.
"""
func _on_Player_bump():
	shake_timer.start()


"""
Varía el offset vertical y horizontal en forma random para
un efecto de vibración.
"""
func shake() -> void:
	self.set_offset(Vector2( \
        rand_range(-1.0, 1.0) * shake_amount, \
        rand_range(-1.0, 1.0) * shake_amount \
    ))


"""
Vuelve a su offset original.
"""
func _on_ShakeTimer_timeout():
	self.set_offset(Vector2.ZERO)
