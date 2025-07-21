extends Node2D

func _on_ground_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
	
