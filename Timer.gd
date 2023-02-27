extends Timer
#kill yourself

onready var timer = $"/root/Main/Camera2D/ColorRect/timer"

func _ready():
	set_wait_time(60)
	
func _process(_delta) -> void:
	timer.set_text(str(get_time_left()).pad_decimals(1))
