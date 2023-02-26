extends KinematicBody2D

export var speed := 50
export var gravity := 400
export var jump := 100
var velocity = Vector2()
onready var bubble = preload("res://Bubble.tscn")
export var ammo := 3
var direction := "right"
onready var bubblecountText = $"/root/Main/Camera2D/ColorRect/Bubble count"
var bounce = false

func _physics_process(delta) -> void: # SHOULDN'T THE MOVEMENT AND JUMPING BE MULTIPLIED BY DELTA?
	# movement and facing a direction
	if velocity.y == 0:
		bounce = false
	
	if bounce == false:
		velocity.x = 0
	else:
		velocity.x = clamp(velocity.x, -50, 50)

	if Input.is_action_pressed("right"):
		velocity.x += speed 
		direction = "right"
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		direction = "left"
	if Input.is_action_pressed("down"):
		direction = "down"
	if Input.is_action_pressed("up"):
		direction = "up"
	
	# jumping
	if Input.is_action_just_pressed("up") && is_on_floor():
		velocity.y = -jump
	
	velocity = move_and_slide(velocity, Vector2.UP)
	if !self.is_on_floor():
		velocity.y += gravity * delta
	
	# shooting bubbles (PROBABLY SHOULDN'T BE IN PHYSICS PROCESS? MAYBE func _input(event): OR 
	# func _process(delta) BUT THESE WERE PUSHING ME)
	if Input.is_action_just_pressed("shoot") && ammo > 0:
		ammo -= 1
		var Bubble = bubble.instance()
		add_child(Bubble)
		Bubble.get_node("bubble/LeftArea2D").connect("left_bubble_collide", self, "touchBubbleLeft")
		Bubble.get_node("bubble/RightArea2D").connect("right_bubble_collide", self, "touchBubbleRight")
		# decides starting position of the bubble depending on the player's direction
		if direction == "right":
			if $rightcast.is_colliding():
				Bubble.position = self.position + Vector2(17, 5)
			else:
				Bubble.position = self.position + Vector2(19, 5)
		elif direction == "left":
			if $leftcast.is_colliding():
				Bubble.position = self.position + Vector2(2, 5)
			else:
				Bubble.position = self.position + Vector2(0, 5)
		elif direction == "down":
			if $downcast.is_colliding():
				Bubble.position = self.position + Vector2(10, 14)
			else:
				Bubble.position = self.position + Vector2(10, 16)
		elif direction == "up":
			if $upcast.is_colliding():
				Bubble.position = self.position + Vector2(10, -3)
			else:
				Bubble.position = self.position + Vector2(10, -5)
		Bubble.set_as_toplevel(true) # makes the bubble not stick to the player
		bubblecountText.set_text(str(ammo))

# refills the bubble ammo count if the player touches the bubble bottle
func _on_Bubble_Refill_body_entered(body):
	if (body == self):
		ammo = 3
		bubblecountText.set_text(str(ammo))

# makes the player bounce off the bubble from the left
func touchBubbleLeft():
	bounce = true
	velocity.y = -jump * 1.5
	if velocity.x != 0:
		velocity.x = 100

# makes the player bounce off the bubble from the right
func touchBubbleRight():
	bounce = true
	velocity.y = -jump * 1.5
	if velocity.x != 0:
		velocity.x = -100
