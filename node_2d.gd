extends Node2D

func _on_Start_Game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://room1.tscn")
