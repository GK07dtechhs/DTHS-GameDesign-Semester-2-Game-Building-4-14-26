extends Area2D

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		var damage = get_meta("damage")
		if damage == null:
			damage = 1 # default fallback
		body.ReduceLives(damage)
