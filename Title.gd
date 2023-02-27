extends Node2D

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if get_tree().change_scene_to(load("res://Level 1.tscn")) != OK:
			print("An unexpected error occured when trying to switch to the Main scene")
	#if event.scancode != KEY_ENTER:
