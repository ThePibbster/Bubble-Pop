extends KinematicBody2D

var timer = Timer.new()
var velocity = Vector2(25, 0)
onready var player = $"/root/Main/player"

func _ready():
	# changes velocity to match the player's direction (if needed)
	if player.direction == "left":
		velocity = Vector2(-25, 0)
	elif player.direction == "down":
		velocity = Vector2(0, 25)
	elif player.direction == "up":
		velocity = Vector2(0, -25)
	
	# creates and starts a 2 second timer that will call the func kill when it's over
	timer.connect("timeout", self, "kill")
	timer.set_wait_time(2)
	timer.one_shot = true # makes the timer not loop
	add_child(timer)
	timer.start()

# deletes the bubble after the timer is up
func kill():
	queue_free()

func _physics_process(delta):
	# makes the bubble bounce when it collides with an object
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
