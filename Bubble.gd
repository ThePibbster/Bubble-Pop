extends KinematicBody2D

var timer = Timer.new()
var velocity = Vector2(25, 0)

func _ready():
	timer.connect("timeout", self, "kill")
	timer.set_wait_time(2)
	timer.one_shot = true
	add_child(timer)
	timer.start()

func kill():
	queue_free()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
