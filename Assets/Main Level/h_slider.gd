extends HSlider


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
