extends TileMapLayer

func _on_area_entered(area: TileMapLayer) -> void:
	if area.is_in_group("Projectile"):
		# Get the local position of the collision from the projectile's global position
		var local_pos = to_local(area.global_position)
		var tile_coords = local_to_map(local_pos)
		print("You hit a vine.")

		# Erase the vine tile from this layer
		erase_cell(tile_coords)

		# Optional: remove the projectile
		area.queue_free()
