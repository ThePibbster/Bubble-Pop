extends Area2D

onready var player = $"/root/Main/player"

# deletes the bubble if it touches the player
func _process(_delta):
	if (overlaps_body(player)):
		get_parent().queue_free()
