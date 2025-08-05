extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		pause_or_unpause()
		
		
		
func pause_or_unpause():
	if get_tree().paused == true:
		$".".hide()
		get_tree().paused = false
	elif get_tree().paused == false:
		$".".show()
		get_tree().paused = true

func _on_button_pressed() -> void:
	pass # Replace with function body.
