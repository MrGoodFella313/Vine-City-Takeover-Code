extends CharacterBody2D
@onready var terget=$"../player"

const SPEED = 300.0
@export var player : Node2D

func _physics_process(Delta):
	var direction = (terget.position - position).normalized()
	velocity = direction * SPEED
	move_and_slide()
