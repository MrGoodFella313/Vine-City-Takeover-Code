extends CharacterBody2D

@export var _rotation_speed : float = TAU * 1
var _theta : float

var health = 100



const SPEED = 125.0
@export var player : Node2D

func _physics_process(_delta: float) -> void:
	#where is the player 
	var direction = (player.position - position).normalized()
	velocity = direction * SPEED
	
	_theta = wrapf(atan2(direction.y, direction.x) - rotation, -PI,PI)
	rotation += clamp(_rotation_speed, 0, abs(_theta)) * sign(_theta)
		
	
	move_and_slide()
	
	
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		print("hit")
	
