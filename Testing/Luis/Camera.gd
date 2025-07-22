extends Camera2D

func _ready() -> void:
	Events.room_entered.connect(func(room):
		print(room)
		global_position = room.global_position
	)
