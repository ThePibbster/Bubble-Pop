extends Area2D

onready var player = $"/root/Main/player"
signal left_bubble_collide

func _process(_delta):
	# deletes the bubble if it touches the player
	if (overlaps_body(player)):
		get_parent().queue_free()
		
		emit_signal("left_bubble_collide") # sends the signal to make the player bounce off the bubble form the left