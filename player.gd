extends KinematicBody2D

export var speed := 10
export var gravity := 2000
export var jump := 200
var velocity = Vector2()

func get_input():
	velocity.x = 0
	#horizontal movement
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	
	#jumping
	if Input.is_action_just_pressed("up") && is_on_floor(): # and touching the ground
		velocity.y = -jump
	
func _physics_process(delta) -> void:
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += gravity * delta
