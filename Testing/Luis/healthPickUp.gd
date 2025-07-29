extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monty"):
		print("Player health increased")
		if body.has_method("heal"):
			body.heal(3)
		else:
			print("Warning: body has no 'heal' method!")
		queue_free()
