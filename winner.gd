extends Control

func _on_mmbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_resbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Main Level/Main Level.tscn")


func _on_quitbtn_pressed() -> void:
	print("quit")
	get_tree().quit()
