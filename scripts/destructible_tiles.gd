extends TileMapLayer

func deleteCell(vector):
	set_cell(vector, -1, Vector2i(0,0))
	

func deleteCellsInRadius(x,y, radius):
	var origin = Vector2i(x, y)
	var radius_squared = radius * radius

	# Loop through a square around the radius
	for dx in range(-radius, radius + 1):
		for dy in range(-radius, radius + 1):
			var pos = origin + Vector2i(dx, dy)
			# Check if the cell is within the circular radius
			if dx * dx + dy * dy <= radius_squared:
				deleteCell(pos)

func _ready() -> void:
	pass
	# deleteCellsInRadius(16, 3, 2)
