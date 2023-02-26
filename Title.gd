extends Node2D

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode != KEY_ENTER:
			get_tree().change_scene_to(load("res://Main.tscn"))
