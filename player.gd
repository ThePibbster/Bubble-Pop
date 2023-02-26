extends KinematicBody2D

export var speed := 50
export var gravity := 400
export var jump := 100
var velocity = Vector2()
onready var bubble = preload("res://Bubble.tscn")
export var ammo := 3
var hdirection := "right"
var vdirection := "none"
onready var bubblecountText = $"/root/Main/Camera2D/ColorRect/Bubble count"
var bounce = false
var pew = preload("res://shoot.wav")
var boing = preload("res://jump.wav")
var wawa = preload ("res://Bottle.wav")

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
		hdirection = "right"
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		hdirection = "left"
	if Input.is_action_pressed("down"):
		vdirection = "down"
	if Input.is_action_pressed("up"):
		vdirection = "up"
	if Input.is_action_just_released("down") || Input.is_action_just_released("up"):
		vdirection = "none"
	
	# jumping
	if Input.is_action_just_pressed("up") && is_on_floor():
		velocity.y = -jump
		if !$JumpAudio.is_playing():
			$JumpAudio.stream = boing
			$JumpAudio.play()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	if !self.is_on_floor():
		velocity.y += gravity * delta
	
	# shooting bubbles (PROBABLY SHOULDN'T BE IN PHYSICS PROCESS? MAYBE func _input(event): OR 
	# func _process(delta) BUT THESE WERE PUSHING ME)
	if Input.is_action_just_pressed("shoot") && ammo > 0:
		if !$ShootAudio.is_playing():
			$ShootAudio.stream = pew
			$ShootAudio.play()
		ammo -= 1
		var Bubble = bubble.instance()
		add_child(Bubble)
		Bubble.get_node("bubble/LeftArea2D").connect("left_bubble_collide", self, "touchBubbleLeft")
		Bubble.get_node("bubble/RightArea2D").connect("right_bubble_collide", self, "touchBubbleRight")
		# decides starting position of the bubble depending on the player's direction
		if vdirection == "down":
			if $downcast.is_colliding():
				Bubble.position = self.position + Vector2(10, 14)
			else:
				Bubble.position = self.position + Vector2(10, 16)
		elif vdirection == "up":
			if $upcast.is_colliding():
				Bubble.position = self.position + Vector2(10, -4)
			else:
				Bubble.position = self.position + Vector2(10, -5)
		elif hdirection == "right":
			if $rightcast.is_colliding():
				Bubble.position = self.position + Vector2(17, 5)
			else:
				Bubble.position = self.position + Vector2(19, 5)
		elif hdirection == "left":
			if $leftcast.is_colliding():
				Bubble.position = self.position + Vector2(2, 5)
			else:
				Bubble.position = self.position + Vector2(0, 5)
		Bubble.set_as_toplevel(true) # makes the bubble not stick to the player
		bubblecountText.set_text(str(ammo))

# refills the bubble ammo count if the player touches the bubble bottle
func _on_Bubble_Refill_body_entered(body):
	if (body == self) && ammo != 3 && !$BottleAudio.is_playing():
		$BottleAudio.stream = wawa
		$BottleAudio.play() 
		ammo = 3
		bubblecountText.set_text(str(ammo))

# makes the player bounce off the bubble from the left
func touchBubbleLeft():
	if !$JumpAudio.is_playing():
			$JumpAudio.stream = boing
			$JumpAudio.play()
	bounce = true
	velocity.y = -jump * 1.5
	if velocity.x != 0:
		velocity.x = 100
		

# makes the player bounce off the bubble from the right
func touchBubbleRight():
	if !$JumpAudio.is_playing():
			$JumpAudio.stream = boing
			$JumpAudio.play()
	bounce = true
	velocity.y = -jump * 1.5
	if velocity.x != 0:
		velocity.x = -100
