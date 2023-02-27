extends Timer

onready var timer = $"/root/Main/Camera2D/ColorRect/timer"

func _ready():
	set_wait_time(90)
	
func _process(_delta) -> void:
	timer.set_text(str(get_time_left()))
