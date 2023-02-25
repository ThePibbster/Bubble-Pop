extends Camera2D

onready var player = get_node("/root/Main/player")

func _process(_delta):
	# makes the camera follow the player
	position.x = player.position.x + 25
	position.y = player.position.y
