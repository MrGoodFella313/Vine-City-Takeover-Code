extends Area2D

@export var room: int = 2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monty"):
		body.update_room(room)
