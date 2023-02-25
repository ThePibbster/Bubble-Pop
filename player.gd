extends KinematicBody2D

export var speed := 50
export var gravity := 400
export var jump := 100
var velocity = Vector2()
onready var bubble = preload("res://Bubble.tscn")
export var ammo := 3
var direction = "right"

func _physics_process(delta) -> void: # SHOULDN'T THE MOVEMENT AND JUMPING BE MULTIPLIED BY DELTA?
	# movement and facing a direction
	velocity.x -= clamp(velocity.x, -50, 50) # bro i literally don't know tbh
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
	velocity.y += gravity * delta
	
	# shooting bubbles (PROBABLY SHOULDN'T BE IN PHYSICS PROCESS? MAYBE func _input(event): OR 
	# func _process(delta) BUT THESE WERE PUSHING ME)
	if Input.is_action_just_pressed("shoot") && ammo > 0:
		ammo -= 1
		var Bubble = bubble.instance()
		add_child(Bubble)
		Bubble.get_node("bubble/Area2D").connect("bubble_collide", self, "touchBubbleLeft")
		# decides starting position of the bubble depending on the player's direction
		if direction == "right":
			Bubble.position = self.position + Vector2(19, 5)
		elif direction == "left":
			Bubble.position = self.position + Vector2(0, 5)
		elif direction == "down":
			Bubble.position = self.position + Vector2(10, 16)
		elif direction == "up":
			Bubble.position = self.position + Vector2(10, -5)
		Bubble.set_as_toplevel(true) # makes the bubble not stick to the player

# refills the bubble ammo count if the player touches the bubble bottle
func _on_Bubble_Refill_body_entered(body):
	if (body == self):
		ammo = 3

# makes the player bounce off the bubble (NOT FINISHED, PROBABLY NEED TO SPLIT THE BUBBLE AREA 2D INTO 2 PARTS OR USE THE (UNUSED) RAY CASTS IDK)
func touchBubbleLeft():
	velocity.y = -jump * 1.5
	velocity.x = 100
