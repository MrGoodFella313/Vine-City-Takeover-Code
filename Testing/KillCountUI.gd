extends Control

@onready var kill_count_label = $KillCountLabel

func _ready():

	var player = get_tree().get_first_node_in_group("player")
	if player:

		player.kill_count_updated.connect(_on_kill_count_updated)

func _on_kill_count_updated(current_kills: int, max_kills: int):
	
	kill_count_label.text = "Jaguars Killed: %d/%d" % [current_kills, max_kills]
