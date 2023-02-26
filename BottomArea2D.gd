extends Area2D

onready var player = $"/root/Main/player"

func _process(_delta):
	# deletes the bubble if it touches the player
	if (overlaps_body(player)):
		get_parent().queue_free()
