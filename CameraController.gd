extends Camera2D

onready var player = get_node("/root/Node2D/player")

func _process(_delta):
	position.x = player.position.x + 25
	position.y = player.position.y
