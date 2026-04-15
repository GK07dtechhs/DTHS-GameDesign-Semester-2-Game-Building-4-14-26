extends RigidBody2D

@onready var timer = $Timer
var destructible_tiles: Node = null

const RADIUS = 4
const DIVISOR = 16

func damage_enemies(x: float, y: float, radius: float):
	var origin = Vector2(x, y)
	var radius_squared = radius * radius
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy:  # safety check
			var dist_squared = enemy.global_position.distance_squared_to(origin)
			if dist_squared <= radius_squared:
				enemy.queue_free()
	var player = get_tree().get_current_scene().find_child("Player")
	if player:
		var dist_squared = player.global_position.distance_squared_to(origin)
		if dist_squared <= radius_squared:
			player.ReduceLives(1)

func _on_timer_timeout():
	var posX = position.x
	var posY = position.y
	posX -= 300
	# posY -= 40
	
	posX /= DIVISOR
	posY /= DIVISOR

	# print(posX)
	# print(posY)
	
	damage_enemies(position.x,position.y, 64)
	destructible_tiles.deleteCellsInRadius(posX, posY, RADIUS)
	queue_free()
	


func _on_ready() -> void:
	timer.start()
