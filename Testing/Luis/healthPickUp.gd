extends Area2D

@export var pickup_amount : int = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is.in.group("Player"):
		print('player health increase')
		"""HealthManager.increase_health(pickup_amount)
		queue_free()"""
