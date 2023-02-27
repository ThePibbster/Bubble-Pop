extends KinematicBody2D

export var speed := 50
export var gravity := 350
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
var up = false

func _physics_process(delta) -> void: # SHOULDN'T THE MOVEMENT AND JUMPING BE MULTIPLIED BY DELTA?
	# movement and facing a direction
	if velocity.y == 0:
		bounce = false
		up = false
	
	if bounce == false:
		velocity.x = 0
	else:
		if !up:
			velocity.x = clamp(velocity.x, -50, 50)
		else:
			velocity.x = clamp(velocity.x, -20, 20)

	if Input.is_action_pressed("right"):
		velocity.x += speed 
		hdirection = "right"
		$AnimatedSprite.play()
		$AnimatedSprite.set_flip_h(false)
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		hdirection = "left"
		$AnimatedSprite.play()
		$AnimatedSprite.set_flip_h(true)
	if Input.is_action_pressed("down"):
		vdirection = "down"
	if Input.is_action_pressed("up"):
		vdirection = "up"
	if Input.is_action_just_released("down") || Input.is_action_just_released("up"):
		vdirection = "none"
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		$AnimatedSprite.frame = 1
		$AnimatedSprite.stop()
	
	# jumping
	if Input.is_action_pressed("up") && is_on_floor():
		velocity.y = -jump
		stopAudio()
		$JumpAudio.stream = boing
		$JumpAudio.play()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	if !self.is_on_floor():
		velocity.y += gravity * delta
	
	# shooting bubbles (PROBABLY SHOULDN'T BE IN PHYSICS PROCESS? MAYBE func _input(event): OR 
	# func _process(delta) BUT THESE WERE PUSHING ME)
	if Input.is_action_just_pressed("shoot") && ammo > 0:
		stopAudio()
		$ShootAudio.stream = pew
		$ShootAudio.play()
		ammo -= 1
		var Bubble = bubble.instance()
		add_child(Bubble)
		Bubble.get_node("bubble/LeftArea2D").connect("left_bubble_collide", self, "touchBubbleLeft")
		Bubble.get_node("bubble/RightArea2D").connect("right_bubble_collide", self, "touchBubbleRight")
		Bubble.get_node("bubble/TopArea2D").connect("top_bubble_collide", self, "touchBubbleTop")
		# decides starting position of the bubble depending on the player's direction
		if vdirection == "down":
			if $downcast.is_colliding():
				Bubble.position = self.position + Vector2(10, 15)
			else:
				Bubble.position = self.position + Vector2(10, 16)
		elif vdirection == "up":
			if $upcast.is_colliding():
				Bubble.position = self.position + Vector2(10, -4)
			else:
				Bubble.position = self.position + Vector2(10, -5)
		elif hdirection == "right":
			if $rightcast.is_colliding():
				Bubble.position = self.position + Vector2(18, 5)
			else:
				Bubble.position = self.position + Vector2(19, 5)
		elif hdirection == "left":
			if $leftcast.is_colliding():
				Bubble.position = self.position + Vector2(1, 5)
			else:
				Bubble.position = self.position + Vector2(0, 5)
		Bubble.set_as_toplevel(true) # makes the bubble not stick to the player
		bubblecountText.set_text(str(ammo))

# refills the bubble ammo count if the player touches the bubble bottle
func _on_Bubble_Refill_body_entered(body):
	if (body == self) && ammo != 3:
		stopAudio()
		$BottleAudio.stream = wawa
		$BottleAudio.play() 
		ammo = 3
		bubblecountText.set_text(str(ammo))

# makes the player bounce off the bubble from the left
func touchBubbleLeft():
	stopAudio()
	$JumpAudio.stream = boing
	$JumpAudio.play()
	bounce = true
	up = false
	velocity.y = -jump * 1.25
	if velocity.x != 0:
		velocity.x = 100

# makes the player bounce off the bubble from the right
func touchBubbleRight():
	stopAudio()
	$JumpAudio.stream = boing
	$JumpAudio.play()
	bounce = true
	up = false
	velocity.y = -jump * 1.25
	if velocity.x != 0:
		velocity.x = -100

# makes the player bounce off the bubble from the top
func touchBubbleTop():
	stopAudio()
	bounce = true
	up = true
	$JumpAudio.stream = boing
	$JumpAudio.play()
	velocity.y = -jump * 1.45

func _on_Timer_timeout():
	if get_tree().change_scene_to(load("res://End.tscn")) != OK:
		print("An unexpected error occured when trying to switch to the End scene")

func stopAudio():
	if $JumpAudio.is_playing():
		$JumpAudio.stop()
	if $ShootAudio.is_playing():
		$ShootAudio.stop()
	if $BottleAudio.is_playing():
		$BottleAudio.stop()
