extends KinematicBody2D

var timer = Timer.new()

func _ready():
	timer.connect("timeout", self, "kill")
	timer.set_wait_time(2)
	timer.one_shot = true
	add_child(timer)
	timer.start()

func kill():
	queue_free()
