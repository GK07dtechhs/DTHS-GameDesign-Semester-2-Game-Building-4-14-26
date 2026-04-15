extends Area2D



func _on_body_entered(body: Node2D):
	if body.name == "Player":
		body.AddCoin(1)
		print(body.Coins)
	queue_free()
