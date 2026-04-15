extends Node

@onready var RespawnTimer = $RespawnTimer
@onready var HUD = $HUD

@onready var LivesDisplay = $HUD/LivesDisplay

@onready var Coins = [
	$HUD/Coin1,
	$HUD/Coin2,
	$HUD/Coin3,
	$HUD/Coin4,
	$HUD/Coin5
]

func update_lives(lives : int):
	LivesDisplay.frame = 3 - lives

func update_coins(coins : int):
	for i in range(Coins.size()):
		if i < coins:
			Coins[i].visible = true
		else:
			Coins[i].visible = false

func game_over(player):
	print("You died!")
	Engine.time_scale = 0.5
	RespawnTimer.start()
	player.get_node("CollisionShape2D").queue_free()

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_respawn_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
