extends Node2D

class_name Door

enum Compass {North, South, East, West}

@export var transition_direction: Compass



	


func _on_body_entered(body):
	Messager.TRIGGER_TRANSITION.emit(transition_direction)

static func get_direction_vector(compass_direction) -> Vector2:
	match(compass_direction):
		Compass.North:
			return Vector2(0, -2)
		Compass.South:
			return Vector2(0, 2)
		Compass.East:
			return Vector2(2, 0)
		Compass.West:
			return Vector2(-2, 0)
	return Vector2()
