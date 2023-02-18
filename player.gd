extends KinematicBody2D

export var speed := 20
export var gravity := 500
export var jump := 100
var velocity = Vector2()

func _physics_process(delta) -> void:
	#horizontal movement
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	
	#jumping
	if Input.is_action_just_pressed("up") && is_on_floor():
		velocity.y = -jump
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("shoot"):
		print("gay")
