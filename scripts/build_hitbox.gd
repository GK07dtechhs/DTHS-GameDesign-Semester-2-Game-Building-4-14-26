extends Area2D

var activated = false
var particles_played = false

func _ready() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not activated:
		var playerCoins = body.Coins
		var cost = get_meta("cost")
		if cost == null:
			cost = 1
		
		# --- PLAY PARTICLES ONCE IF PLAYER HAS ≥1 COIN ---
		if playerCoins >= 1 and not particles_played:
			var particle_names = ["CPUParticles2D", "CPUParticles2D2", "CPUParticles2D3", "CPUParticles2D4"]
			for name in particle_names:
				var particles = get_node("CloudsTest/" + name)
				if particles and particles is CPUParticles2D:
					print("Playing:", name) # debug
					particles.visible = true
					particles.emitting = false  # reset emitting
					particles.restart()          # restart particles
					particles.emitting = true   # start emitting
			
			particles_played = true
		
		# --- EXISTING PURCHASE LOGIC ---
		if (playerCoins - cost) >= 0:
			body.AddCoin((0 - cost))
			var itemName = get_meta("ItemName")
			if itemName != null:
				var item = get_tree().get_current_scene().get_node("BuildingParts").get_node(itemName)
				activated = true
				item.OnBuild()
