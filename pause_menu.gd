extends Control

var _is_paused:bool = false:
	set = set_paused
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		_is_paused = !_is_paused
		
		
func set_paused(value:bool) -> void:
	print("pause")
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	
	
func _on_resumebtn_pressed() -> void:
	print("resume")
	_is_paused = false
	
func _on_quit_btn_pressed() -> void:
	print("quit")
	get_tree().quit()

func _on_main_men_ubtn_pressed() -> void:
	_is_paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
