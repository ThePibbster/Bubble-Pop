extends Area2D

onready var player = $"/root/Main/player"
signal bottle_refill_collide

func _process(_delta):
	if (overlaps_body(player)):
		emit_signal("bottle_refill_collide")
