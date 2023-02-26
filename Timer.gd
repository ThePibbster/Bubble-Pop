extends Timer


onready var timer = $"/root/Main/Camera2D/ColorRect/timer"

func _ready():
	set_wait_time(20)
	
func _process(delta) -> void:
	timer.set_text(str(get_time_left()).pad_decimals(1))
