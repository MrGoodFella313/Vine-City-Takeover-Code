extends Area2D


func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area):
	print(area)
	#area.queue_free()
	#get_parent().queue_free()
