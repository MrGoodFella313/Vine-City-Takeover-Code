extends CharacterBody2D


const SPEED = 300.0

signal healthChanged

func _physics_process(_delta):
	
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()


	healthChanged.emit()
